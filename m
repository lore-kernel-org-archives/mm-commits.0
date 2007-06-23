From: akpm@linux-foundation.org
Subject: + update-procfs-guide-doc-of-read_func.patch added to -mm tree
Date: Sat, 23 Jun 2007 09:53:19 -0700
Message-ID: <200706231653.l5NGrG6a019663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48880 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761070AbXFWQxm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 12:53:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cscott@laptop.org, ebiederm@xmission.com, rdunlap@xenotime.net


The patch titled
     update procfs-guide doc of read_func
has been added to the -mm tree.  Its filename is
     update-procfs-guide-doc-of-read_func.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: update procfs-guide doc of read_func
From: "C. Scott Ananian" <cscott@laptop.org>

The procfs-guide claims that 'the parameter start doesn't seem to be used
anywhere in the kernel'.  This is out of date.  In linux/fs/proc/generic.c
we find a very nice description of the parameters to read_func.  The
appended patch replaces the bogus description with this (as far as I know)
accurate one.

Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/procfs-guide.tmpl |   82 ++++++++++++++++------
 1 file changed, 63 insertions(+), 19 deletions(-)

diff -puN Documentation/DocBook/procfs-guide.tmpl~update-procfs-guide-doc-of-read_func Documentation/DocBook/procfs-guide.tmpl
--- a/Documentation/DocBook/procfs-guide.tmpl~update-procfs-guide-doc-of-read_func
+++ a/Documentation/DocBook/procfs-guide.tmpl
@@ -352,49 +352,93 @@ entry->write_proc = write_proc_foo;
       <funcsynopsis>
 	<funcprototype>
 	  <funcdef>int <function>read_func</function></funcdef>
-	  <paramdef>char* <parameter>page</parameter></paramdef>
+	  <paramdef>char* <parameter>buffer</parameter></paramdef>
 	  <paramdef>char** <parameter>start</parameter></paramdef>
 	  <paramdef>off_t <parameter>off</parameter></paramdef>
 	  <paramdef>int <parameter>count</parameter></paramdef>
-	  <paramdef>int* <parameter>eof</parameter></paramdef>
+	  <paramdef>int* <parameter>peof</parameter></paramdef>
 	  <paramdef>void* <parameter>data</parameter></paramdef>
 	</funcprototype>
       </funcsynopsis>
 
       <para>
         The read function should write its information into the
-        <parameter>page</parameter>. For proper use, the function
-        should start writing at an offset of
-        <parameter>off</parameter> in <parameter>page</parameter> and
-        write at most <parameter>count</parameter> bytes, but because
-        most read functions are quite simple and only return a small
-        amount of information, these two parameters are usually
-        ignored (it breaks pagers like <literal>more</literal> and
-        <literal>less</literal>, but <literal>cat</literal> still
-        works).
+        <parameter>buffer</parameter>, which will be exactly
+        <literal>PAGE_SIZE</literal> bytes long.
       </para>
 
       <para>
-        If the <parameter>off</parameter> and
-        <parameter>count</parameter> parameters are properly used,
-        <parameter>eof</parameter> should be used to signal that the
+        The parameter
+        <parameter>peof</parameter> should be used to signal that the
         end of the file has been reached by writing
         <literal>1</literal> to the memory location
-        <parameter>eof</parameter> points to.
+        <parameter>peof</parameter> points to.
       </para>
 
       <para>
-        The parameter <parameter>start</parameter> doesn't seem to be
-        used anywhere in the kernel. The <parameter>data</parameter>
+        The <parameter>data</parameter>
         parameter can be used to create a single call back function for
         several files, see <xref linkend="usingdata"/>.
       </para>
 
       <para>
-        The <function>read_func</function> function must return the
-        number of bytes written into the <parameter>page</parameter>.
+        The rest of the parameters and the return value are described
+	by a comment in <filename>fs/proc/generic.c</filename> as follows:
       </para>
 
+      <blockquote>
+        <para>
+	You have three ways to return data:
+       	</para>
+        <orderedlist>
+          <listitem>
+            <para>
+	      Leave <literal>*start = NULL</literal>.  (This is the default.)
+	      Put the data of the requested offset at that
+	      offset within the buffer.  Return the number (<literal>n</literal>)
+	      of bytes there are from the beginning of the
+	      buffer up to the last byte of data.  If the
+	      number of supplied bytes (<literal>= n - offset</literal>) is
+	      greater than zero and you didn't signal eof
+	      and the reader is prepared to take more data
+	      you will be called again with the requested
+	      offset advanced by the number of bytes
+	      absorbed.  This interface is useful for files
+	      no larger than the buffer.
+	    </para>
+	  </listitem>
+	  <listitem>
+            <para>
+	      Set <literal>*start</literal> to an unsigned long value less than
+	      the buffer address but greater than zero.
+	      Put the data of the requested offset at the
+	      beginning of the buffer.  Return the number of
+	      bytes of data placed there.  If this number is
+	      greater than zero and you didn't signal eof
+	      and the reader is prepared to take more data
+	      you will be called again with the requested
+	      offset advanced by <literal>*start</literal>.  This interface is
+	      useful when you have a large file consisting
+	      of a series of blocks which you want to count
+	      and return as wholes.
+	      (Hack by Paul.Russell@rustcorp.com.au)
+	    </para>
+	  </listitem>
+	  <listitem>
+            <para>
+	      Set <literal>*start</literal> to an address within the buffer.
+	      Put the data of the requested offset at <literal>*start</literal>.
+	      Return the number of bytes of data placed there.
+	      If this number is greater than zero and you
+	      didn't signal eof and the reader is prepared to
+	      take more data you will be called again with the
+	      requested offset advanced by the number of bytes
+	      absorbed.
+	    </para>
+	  </listitem>
+	</orderedlist>
+      </blockquote>
+
       <para>
         <xref linkend="example"/> shows how to use a read call back
         function.
_

Patches currently in -mm which might be from cscott@laptop.org are

update-procfs-guide-doc-of-read_func.patch
