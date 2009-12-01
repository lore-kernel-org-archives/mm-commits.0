From: akpm@linux-foundation.org
Subject: + proc-remove-docbook-and-example.patch added to -mm tree
Date: Tue, 01 Dec 2009 14:34:01 -0800
Message-ID: <200912012234.nB1MY1AY030242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751957AbZLAWer (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2009 17:34:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, mouw@nl.linux.org, randy.dunlap@oracle.com


The patch titled
     proc: remove docbook and example
has been added to the -mm tree.  Its filename is
     proc-remove-docbook-and-example.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: remove docbook and example
From: Alexey Dobriyan <adobriyan@gmail.com>

Example is outdated, it still uses old ->read_proc interfaces and "fb"
example is plain racy.  There are better examples all over the tree.

Docbook itself says almost nothing about /proc and contain quite a number
of simply wrong facts, e.g.  device nodes support.  What it does is
describing at great length interface which are going to be removed.

There are Documentation/filesystems/seq_file.txt in exchange.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Erik Mouw <mouw@nl.linux.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/Makefile          |   17 
 Documentation/DocBook/procfs-guide.tmpl |  626 ----------------------
 Documentation/DocBook/procfs_example.c  |  201 -------
 3 files changed, 3 insertions(+), 841 deletions(-)

diff -puN Documentation/DocBook/Makefile~proc-remove-docbook-and-example Documentation/DocBook/Makefile
--- a/Documentation/DocBook/Makefile~proc-remove-docbook-and-example
+++ a/Documentation/DocBook/Makefile
@@ -8,7 +8,7 @@
 
 DOCBOOKS := z8530book.xml mcabook.xml device-drivers.xml \
 	    kernel-hacking.xml kernel-locking.xml deviceiobook.xml \
-	    procfs-guide.xml writing_usb_driver.xml networking.xml \
+	    writing_usb_driver.xml networking.xml \
 	    kernel-api.xml filesystems.xml lsm.xml usb.xml kgdb.xml \
 	    gadget.xml libata.xml mtdnand.xml librs.xml rapidio.xml \
 	    genericirq.xml s390-drivers.xml uio-howto.xml scsi.xml \
@@ -65,7 +65,7 @@ KERNELDOC = $(srctree)/scripts/kernel-do
 DOCPROC   = $(objtree)/scripts/basic/docproc
 
 XMLTOFLAGS = -m $(srctree)/Documentation/DocBook/stylesheet.xsl
-#XMLTOFLAGS += --skip-validation
+XMLTOFLAGS += --skip-validation
 
 ###
 # DOCPROC is used for two purposes:
@@ -101,17 +101,6 @@ endif
 # Changes in kernel-doc force a rebuild of all documentation
 $(BOOKS): $(KERNELDOC)
 
-###
-# procfs guide uses a .c file as example code.
-# This requires an explicit dependency
-C-procfs-example = procfs_example.xml
-C-procfs-example2 = $(addprefix $(obj)/,$(C-procfs-example))
-$(obj)/procfs-guide.xml: $(C-procfs-example2)
-
-# List of programs to build
-##oops, this is a kernel module::hostprogs-y := procfs_example
-obj-m += procfs_example.o
-
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
 
@@ -238,7 +227,7 @@ clean-files := $(DOCBOOKS) \
 	$(patsubst %.xml, %.pdf,  $(DOCBOOKS)) \
 	$(patsubst %.xml, %.html, $(DOCBOOKS)) \
 	$(patsubst %.xml, %.9,    $(DOCBOOKS)) \
-	$(C-procfs-example) $(index)
+	$(index)
 
 clean-dirs := $(patsubst %.xml,%,$(DOCBOOKS)) man
 
diff -puN Documentation/DocBook/procfs-guide.tmpl~proc-remove-docbook-and-example /dev/null
--- a/Documentation/DocBook/procfs-guide.tmpl
+++ /dev/null
@@ -1,626 +0,0 @@
-<?xml version="1.0" encoding="UTF-8"?>
-<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.1.2//EN"
-	"http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd" [
-<!ENTITY procfsexample SYSTEM "procfs_example.xml">
-]>
-
-<book id="LKProcfsGuide">
-  <bookinfo>
-    <title>Linux Kernel Procfs Guide</title>
-
-    <authorgroup>
-      <author>
-	<firstname>Erik</firstname>
-	<othername>(J.A.K.)</othername>
-	<surname>Mouw</surname>
-	<affiliation>
-	  <address>
-            <email>mouw@nl.linux.org</email>
-          </address>
-	</affiliation>
-      </author>
-      <othercredit>
-	<contrib>
-	This software and documentation were written while working on the
-	LART computing board
-	(<ulink url="http://www.lartmaker.nl/">http://www.lartmaker.nl/</ulink>),
-	which was sponsored by the Delt University of Technology projects
-	Mobile Multi-media Communications and Ubiquitous Communications.
-	</contrib>
-      </othercredit>
-    </authorgroup>
-
-    <revhistory>
-      <revision>
-	<revnumber>1.0</revnumber>
-	<date>May 30, 2001</date>
-	<revremark>Initial revision posted to linux-kernel</revremark>
-      </revision>
-      <revision>
-	<revnumber>1.1</revnumber>
-	<date>June 3, 2001</date>
-	<revremark>Revised after comments from linux-kernel</revremark>
-      </revision>
-    </revhistory>
-
-    <copyright>
-      <year>2001</year>
-      <holder>Erik Mouw</holder>
-    </copyright>
-
-
-    <legalnotice>
-      <para>
-        This documentation is free software; you can redistribute it
-        and/or modify it under the terms of the GNU General Public
-        License as published by the Free Software Foundation; either
-        version 2 of the License, or (at your option) any later
-        version.
-      </para>
-      
-      <para>
-        This documentation is distributed in the hope that it will be
-        useful, but WITHOUT ANY WARRANTY; without even the implied
-        warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
-        PURPOSE.  See the GNU General Public License for more details.
-      </para>
-      
-      <para>
-        You should have received a copy of the GNU General Public
-        License along with this program; if not, write to the Free
-        Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
-        MA 02111-1307 USA
-      </para>
-      
-      <para>
-        For more details see the file COPYING in the source
-        distribution of Linux.
-      </para>
-    </legalnotice>
-  </bookinfo>
-
-
-
-
-  <toc>
-  </toc>
-
-
-
-
-  <preface id="Preface">
-    <title>Preface</title>
-
-    <para>
-      This guide describes the use of the procfs file system from
-      within the Linux kernel. The idea to write this guide came up on
-      the #kernelnewbies IRC channel (see <ulink
-      url="http://www.kernelnewbies.org/">http://www.kernelnewbies.org/</ulink>),
-      when Jeff Garzik explained the use of procfs and forwarded me a
-      message Alexander Viro wrote to the linux-kernel mailing list. I
-      agreed to write it up nicely, so here it is.
-    </para>
-
-    <para>
-      I'd like to thank Jeff Garzik
-      <email>jgarzik@pobox.com</email> and Alexander Viro
-      <email>viro@parcelfarce.linux.theplanet.co.uk</email> for their input,
-      Tim Waugh <email>twaugh@redhat.com</email> for his <ulink
-      url="http://people.redhat.com/twaugh/docbook/selfdocbook/">Selfdocbook</ulink>,
-      and Marc Joosen <email>marcj@historia.et.tudelft.nl</email> for
-      proofreading.
-    </para>
-
-    <para>
-      Erik
-    </para>
-  </preface>
-
-
-
-
-  <chapter id="intro">
-    <title>Introduction</title>
-
-    <para>
-      The <filename class="directory">/proc</filename> file system
-      (procfs) is a special file system in the linux kernel. It's a
-      virtual file system: it is not associated with a block device
-      but exists only in memory. The files in the procfs are there to
-      allow userland programs access to certain information from the
-      kernel (like process information in <filename
-      class="directory">/proc/[0-9]+/</filename>), but also for debug
-      purposes (like <filename>/proc/ksyms</filename>).
-    </para>
-
-    <para>
-      This guide describes the use of the procfs file system from
-      within the Linux kernel. It starts by introducing all relevant
-      functions to manage the files within the file system. After that
-      it shows how to communicate with userland, and some tips and
-      tricks will be pointed out. Finally a complete example will be
-      shown.
-    </para>
-
-    <para>
-      Note that the files in <filename
-      class="directory">/proc/sys</filename> are sysctl files: they
-      don't belong to procfs and are governed by a completely
-      different API described in the Kernel API book.
-    </para>
-  </chapter>
-
-
-
-
-  <chapter id="managing">
-    <title>Managing procfs entries</title>
-    
-    <para>
-      This chapter describes the functions that various kernel
-      components use to populate the procfs with files, symlinks,
-      device nodes, and directories.
-    </para>
-
-    <para>
-      A minor note before we start: if you want to use any of the
-      procfs functions, be sure to include the correct header file! 
-      This should be one of the first lines in your code:
-    </para>
-
-    <programlisting>
-#include &lt;linux/proc_fs.h&gt;
-    </programlisting>
-
-
-
-
-    <sect1 id="regularfile">
-      <title>Creating a regular file</title>
-      
-      <funcsynopsis>
-	<funcprototype>
-	  <funcdef>struct proc_dir_entry* <function>create_proc_entry</function></funcdef>
-	  <paramdef>const char* <parameter>name</parameter></paramdef>
-	  <paramdef>mode_t <parameter>mode</parameter></paramdef>
-	  <paramdef>struct proc_dir_entry* <parameter>parent</parameter></paramdef>
-	</funcprototype>
-      </funcsynopsis>
-
-      <para>
-        This function creates a regular file with the name
-        <parameter>name</parameter>, file mode
-        <parameter>mode</parameter> in the directory
-        <parameter>parent</parameter>. To create a file in the root of
-        the procfs, use <constant>NULL</constant> as
-        <parameter>parent</parameter> parameter. When successful, the
-        function will return a pointer to the freshly created
-        <structname>struct proc_dir_entry</structname>; otherwise it
-        will return <constant>NULL</constant>. <xref
-        linkend="userland"/> describes how to do something useful with
-        regular files.
-      </para>
-
-      <para>
-        Note that it is specifically supported that you can pass a
-        path that spans multiple directories. For example
-        <function>create_proc_entry</function>(<parameter>"drivers/via0/info"</parameter>)
-        will create the <filename class="directory">via0</filename>
-        directory if necessary, with standard
-        <constant>0755</constant> permissions.
-      </para>
-
-    <para>
-      If you only want to be able to read the file, the function
-      <function>create_proc_read_entry</function> described in <xref
-      linkend="convenience"/> may be used to create and initialise
-      the procfs entry in one single call.
-    </para>
-    </sect1>
-
-
-
-
-    <sect1 id="Creating_a_symlink">
-      <title>Creating a symlink</title>
-
-      <funcsynopsis>
-	<funcprototype>
-	  <funcdef>struct proc_dir_entry*
-	  <function>proc_symlink</function></funcdef> <paramdef>const
-	  char* <parameter>name</parameter></paramdef>
-	  <paramdef>struct proc_dir_entry*
-	  <parameter>parent</parameter></paramdef> <paramdef>const
-	  char* <parameter>dest</parameter></paramdef>
-	</funcprototype>
-      </funcsynopsis>
-      
-      <para>
-        This creates a symlink in the procfs directory
-        <parameter>parent</parameter> that points from
-        <parameter>name</parameter> to
-        <parameter>dest</parameter>. This translates in userland to
-        <literal>ln -s</literal> <parameter>dest</parameter>
-        <parameter>name</parameter>.
-      </para>
-    </sect1>
-
-    <sect1 id="Creating_a_directory">
-      <title>Creating a directory</title>
-      
-      <funcsynopsis>
-	<funcprototype>
-	  <funcdef>struct proc_dir_entry* <function>proc_mkdir</function></funcdef>
-	  <paramdef>const char* <parameter>name</parameter></paramdef>
-	  <paramdef>struct proc_dir_entry* <parameter>parent</parameter></paramdef>
-	</funcprototype>
-      </funcsynopsis>
-
-      <para>
-        Create a directory <parameter>name</parameter> in the procfs
-        directory <parameter>parent</parameter>.
-      </para>
-    </sect1>
-
-
-
-
-    <sect1 id="Removing_an_entry">
-      <title>Removing an entry</title>
-      
-      <funcsynopsis>
-	<funcprototype>
-	  <funcdef>void <function>remove_proc_entry</function></funcdef>
-	  <paramdef>const char* <parameter>name</parameter></paramdef>
-	  <paramdef>struct proc_dir_entry* <parameter>parent</parameter></paramdef>
-	</funcprototype>
-      </funcsynopsis>
-
-      <para>
-        Removes the entry <parameter>name</parameter> in the directory
-        <parameter>parent</parameter> from the procfs. Entries are
-        removed by their <emphasis>name</emphasis>, not by the
-        <structname>struct proc_dir_entry</structname> returned by the
-        various create functions. Note that this function doesn't
-        recursively remove entries.
-      </para>
-
-      <para>
-        Be sure to free the <structfield>data</structfield> entry from
-        the <structname>struct proc_dir_entry</structname> before
-        <function>remove_proc_entry</function> is called (that is: if
-        there was some <structfield>data</structfield> allocated, of
-        course). See <xref linkend="usingdata"/> for more information
-        on using the <structfield>data</structfield> entry.
-      </para>
-    </sect1>
-  </chapter>
-
-
-
-
-  <chapter id="userland">
-    <title>Communicating with userland</title>
-    
-    <para>
-       Instead of reading (or writing) information directly from
-       kernel memory, procfs works with <emphasis>call back
-       functions</emphasis> for files: functions that are called when
-       a specific file is being read or written. Such functions have
-       to be initialised after the procfs file is created by setting
-       the <structfield>read_proc</structfield> and/or
-       <structfield>write_proc</structfield> fields in the
-       <structname>struct proc_dir_entry*</structname> that the
-       function <function>create_proc_entry</function> returned:
-    </para>
-
-    <programlisting>
-struct proc_dir_entry* entry;
-
-entry->read_proc = read_proc_foo;
-entry->write_proc = write_proc_foo;
-    </programlisting>
-
-    <para>
-      If you only want to use a the
-      <structfield>read_proc</structfield>, the function
-      <function>create_proc_read_entry</function> described in <xref
-      linkend="convenience"/> may be used to create and initialise the
-      procfs entry in one single call.
-    </para>
-
-
-
-    <sect1 id="Reading_data">
-      <title>Reading data</title>
-
-      <para>
-        The read function is a call back function that allows userland
-        processes to read data from the kernel. The read function
-        should have the following format:
-      </para>
-
-      <funcsynopsis>
-	<funcprototype>
-	  <funcdef>int <function>read_func</function></funcdef>
-	  <paramdef>char* <parameter>buffer</parameter></paramdef>
-	  <paramdef>char** <parameter>start</parameter></paramdef>
-	  <paramdef>off_t <parameter>off</parameter></paramdef>
-	  <paramdef>int <parameter>count</parameter></paramdef>
-	  <paramdef>int* <parameter>peof</parameter></paramdef>
-	  <paramdef>void* <parameter>data</parameter></paramdef>
-	</funcprototype>
-      </funcsynopsis>
-
-      <para>
-        The read function should write its information into the
-        <parameter>buffer</parameter>, which will be exactly
-        <literal>PAGE_SIZE</literal> bytes long.
-      </para>
-
-      <para>
-        The parameter
-        <parameter>peof</parameter> should be used to signal that the
-        end of the file has been reached by writing
-        <literal>1</literal> to the memory location
-        <parameter>peof</parameter> points to.
-      </para>
-
-      <para>
-        The <parameter>data</parameter>
-        parameter can be used to create a single call back function for
-        several files, see <xref linkend="usingdata"/>.
-      </para>
-
-      <para>
-        The rest of the parameters and the return value are described
-	by a comment in <filename>fs/proc/generic.c</filename> as follows:
-      </para>
-
-      <blockquote>
-        <para>
-	You have three ways to return data:
-       	</para>
-        <orderedlist>
-          <listitem>
-            <para>
-	      Leave <literal>*start = NULL</literal>.  (This is the default.)
-	      Put the data of the requested offset at that
-	      offset within the buffer.  Return the number (<literal>n</literal>)
-	      of bytes there are from the beginning of the
-	      buffer up to the last byte of data.  If the
-	      number of supplied bytes (<literal>= n - offset</literal>) is
-	      greater than zero and you didn't signal eof
-	      and the reader is prepared to take more data
-	      you will be called again with the requested
-	      offset advanced by the number of bytes
-	      absorbed.  This interface is useful for files
-	      no larger than the buffer.
-	    </para>
-	  </listitem>
-	  <listitem>
-            <para>
-	      Set <literal>*start</literal> to an unsigned long value less than
-	      the buffer address but greater than zero.
-	      Put the data of the requested offset at the
-	      beginning of the buffer.  Return the number of
-	      bytes of data placed there.  If this number is
-	      greater than zero and you didn't signal eof
-	      and the reader is prepared to take more data
-	      you will be called again with the requested
-	      offset advanced by <literal>*start</literal>.  This interface is
-	      useful when you have a large file consisting
-	      of a series of blocks which you want to count
-	      and return as wholes.
-	      (Hack by Paul.Russell@rustcorp.com.au)
-	    </para>
-	  </listitem>
-	  <listitem>
-            <para>
-	      Set <literal>*start</literal> to an address within the buffer.
-	      Put the data of the requested offset at <literal>*start</literal>.
-	      Return the number of bytes of data placed there.
-	      If this number is greater than zero and you
-	      didn't signal eof and the reader is prepared to
-	      take more data you will be called again with the
-	      requested offset advanced by the number of bytes
-	      absorbed.
-	    </para>
-	  </listitem>
-	</orderedlist>
-      </blockquote>
-
-      <para>
-        <xref linkend="example"/> shows how to use a read call back
-        function.
-      </para>
-    </sect1>
-
-
-
-
-    <sect1 id="Writing_data">
-      <title>Writing data</title>
-
-      <para>
-        The write call back function allows a userland process to write
-        data to the kernel, so it has some kind of control over the
-        kernel. The write function should have the following format:
-      </para>
-
-      <funcsynopsis>
-	<funcprototype>
-	  <funcdef>int <function>write_func</function></funcdef>
-	  <paramdef>struct file* <parameter>file</parameter></paramdef>
-	  <paramdef>const char* <parameter>buffer</parameter></paramdef>
-	  <paramdef>unsigned long <parameter>count</parameter></paramdef>
-	  <paramdef>void* <parameter>data</parameter></paramdef>
-	</funcprototype>
-      </funcsynopsis>
-
-      <para>
-        The write function should read <parameter>count</parameter>
-        bytes at maximum from the <parameter>buffer</parameter>. Note
-        that the <parameter>buffer</parameter> doesn't live in the
-        kernel's memory space, so it should first be copied to kernel
-        space with <function>copy_from_user</function>. The
-        <parameter>file</parameter> parameter is usually
-        ignored. <xref linkend="usingdata"/> shows how to use the
-        <parameter>data</parameter> parameter.
-      </para>
-
-      <para>
-        Again, <xref linkend="example"/> shows how to use this call back
-        function.
-      </para>
-    </sect1>
-
-
-
-
-    <sect1 id="usingdata">
-      <title>A single call back for many files</title>
-
-      <para>
-         When a large number of almost identical files is used, it's
-         quite inconvenient to use a separate call back function for
-         each file. A better approach is to have a single call back
-         function that distinguishes between the files by using the
-         <structfield>data</structfield> field in <structname>struct
-         proc_dir_entry</structname>. First of all, the
-         <structfield>data</structfield> field has to be initialised:
-      </para>
-
-      <programlisting>
-struct proc_dir_entry* entry;
-struct my_file_data *file_data;
-
-file_data = kmalloc(sizeof(struct my_file_data), GFP_KERNEL);
-entry->data = file_data;
-      </programlisting>
-     
-      <para>
-          The <structfield>data</structfield> field is a <type>void
-          *</type>, so it can be initialised with anything.
-      </para>
-
-      <para>
-        Now that the <structfield>data</structfield> field is set, the
-        <function>read_proc</function> and
-        <function>write_proc</function> can use it to distinguish
-        between files because they get it passed into their
-        <parameter>data</parameter> parameter:
-      </para>
-
-      <programlisting>
-int foo_read_func(char *page, char **start, off_t off,
-                  int count, int *eof, void *data)
-{
-        int len;
-
-        if(data == file_data) {
-                /* special case for this file */
-        } else {
-                /* normal processing */
-        }
-
-        return len;
-}
-      </programlisting>
-
-      <para>
-        Be sure to free the <structfield>data</structfield> data field
-        when removing the procfs entry.
-      </para>
-    </sect1>
-  </chapter>
-
-
-
-
-  <chapter id="tips">
-    <title>Tips and tricks</title>
-
-
-
-
-    <sect1 id="convenience">
-      <title>Convenience functions</title>
-
-      <funcsynopsis>
-	<funcprototype>
-	  <funcdef>struct proc_dir_entry* <function>create_proc_read_entry</function></funcdef>
-	  <paramdef>const char* <parameter>name</parameter></paramdef>
-	  <paramdef>mode_t <parameter>mode</parameter></paramdef>
-	  <paramdef>struct proc_dir_entry* <parameter>parent</parameter></paramdef>
-	  <paramdef>read_proc_t* <parameter>read_proc</parameter></paramdef>
-	  <paramdef>void* <parameter>data</parameter></paramdef>
-	</funcprototype>
-      </funcsynopsis>
-      
-      <para>
-        This function creates a regular file in exactly the same way
-        as <function>create_proc_entry</function> from <xref
-        linkend="regularfile"/> does, but also allows to set the read
-        function <parameter>read_proc</parameter> in one call. This
-        function can set the <parameter>data</parameter> as well, like
-        explained in <xref linkend="usingdata"/>.
-      </para>
-    </sect1>
-
-
-
-    <sect1 id="Modules">
-      <title>Modules</title>
-
-      <para>
-        If procfs is being used from within a module, be sure to set
-        the <structfield>owner</structfield> field in the
-        <structname>struct proc_dir_entry</structname> to
-        <constant>THIS_MODULE</constant>.
-      </para>
-
-      <programlisting>
-struct proc_dir_entry* entry;
-
-entry->owner = THIS_MODULE;
-      </programlisting>
-    </sect1>
-
-
-
-
-    <sect1 id="Mode_and_ownership">
-      <title>Mode and ownership</title>
-
-      <para>
-        Sometimes it is useful to change the mode and/or ownership of
-        a procfs entry. Here is an example that shows how to achieve
-        that:
-      </para>
-
-      <programlisting>
-struct proc_dir_entry* entry;
-
-entry->mode =  S_IWUSR |S_IRUSR | S_IRGRP | S_IROTH;
-entry->uid = 0;
-entry->gid = 100;
-      </programlisting>
-
-    </sect1>
-  </chapter>
-
-
-
-
-  <chapter id="example">
-    <title>Example</title>
-
-    <!-- be careful with the example code: it shouldn't be wider than
-    approx. 60 columns, or otherwise it won't fit properly on a page
-    -->
-
-&procfsexample;
-
-  </chapter>
-</book>
diff -puN Documentation/DocBook/procfs_example.c~proc-remove-docbook-and-example /dev/null
--- a/Documentation/DocBook/procfs_example.c
+++ /dev/null
@@ -1,201 +0,0 @@
-/*
- * procfs_example.c: an example proc interface
- *
- * Copyright (C) 2001, Erik Mouw (mouw@nl.linux.org)
- *
- * This file accompanies the procfs-guide in the Linux kernel
- * source. Its main use is to demonstrate the concepts and
- * functions described in the guide.
- *
- * This software has been developed while working on the LART
- * computing board (http://www.lartmaker.nl), which was sponsored
- * by the Delt University of Technology projects Mobile Multi-media
- * Communications and Ubiquitous Communications.
- *
- * This program is free software; you can redistribute
- * it and/or modify it under the terms of the GNU General
- * Public License as published by the Free Software
- * Foundation; either version 2 of the License, or (at your
- * option) any later version.
- *
- * This program is distributed in the hope that it will be
- * useful, but WITHOUT ANY WARRANTY; without even the implied
- * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
- * PURPOSE.  See the GNU General Public License for more
- * details.
- * 
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place,
- * Suite 330, Boston, MA  02111-1307  USA
- *
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/proc_fs.h>
-#include <linux/jiffies.h>
-#include <asm/uaccess.h>
-
-
-#define MODULE_VERS "1.0"
-#define MODULE_NAME "procfs_example"
-
-#define FOOBAR_LEN 8
-
-struct fb_data_t {
-	char name[FOOBAR_LEN + 1];
-	char value[FOOBAR_LEN + 1];
-};
-
-
-static struct proc_dir_entry *example_dir, *foo_file,
-	*bar_file, *jiffies_file, *symlink;
-
-
-struct fb_data_t foo_data, bar_data;
-
-
-static int proc_read_jiffies(char *page, char **start,
-			     off_t off, int count,
-			     int *eof, void *data)
-{
-	int len;
-
-	len = sprintf(page, "jiffies = %ld\n",
-                      jiffies);
-
-	return len;
-}
-
-
-static int proc_read_foobar(char *page, char **start,
-			    off_t off, int count, 
-			    int *eof, void *data)
-{
-	int len;
-	struct fb_data_t *fb_data = (struct fb_data_t *)data;
-
-	/* DON'T DO THAT - buffer overruns are bad */
-	len = sprintf(page, "%s = '%s'\n", 
-		      fb_data->name, fb_data->value);
-
-	return len;
-}
-
-
-static int proc_write_foobar(struct file *file,
-			     const char *buffer,
-			     unsigned long count, 
-			     void *data)
-{
-	int len;
-	struct fb_data_t *fb_data = (struct fb_data_t *)data;
-
-	if(count > FOOBAR_LEN)
-		len = FOOBAR_LEN;
-	else
-		len = count;
-
-	if(copy_from_user(fb_data->value, buffer, len))
-		return -EFAULT;
-
-	fb_data->value[len] = '\0';
-
-	return len;
-}
-
-
-static int __init init_procfs_example(void)
-{
-	int rv = 0;
-
-	/* create directory */
-	example_dir = proc_mkdir(MODULE_NAME, NULL);
-	if(example_dir == NULL) {
-		rv = -ENOMEM;
-		goto out;
-	}
-	/* create jiffies using convenience function */
-	jiffies_file = create_proc_read_entry("jiffies", 
-					      0444, example_dir, 
-					      proc_read_jiffies,
-					      NULL);
-	if(jiffies_file == NULL) {
-		rv  = -ENOMEM;
-		goto no_jiffies;
-	}
-
-	/* create foo and bar files using same callback
-	 * functions 
-	 */
-	foo_file = create_proc_entry("foo", 0644, example_dir);
-	if(foo_file == NULL) {
-		rv = -ENOMEM;
-		goto no_foo;
-	}
-
-	strcpy(foo_data.name, "foo");
-	strcpy(foo_data.value, "foo");
-	foo_file->data = &foo_data;
-	foo_file->read_proc = proc_read_foobar;
-	foo_file->write_proc = proc_write_foobar;
-		
-	bar_file = create_proc_entry("bar", 0644, example_dir);
-	if(bar_file == NULL) {
-		rv = -ENOMEM;
-		goto no_bar;
-	}
-
-	strcpy(bar_data.name, "bar");
-	strcpy(bar_data.value, "bar");
-	bar_file->data = &bar_data;
-	bar_file->read_proc = proc_read_foobar;
-	bar_file->write_proc = proc_write_foobar;
-		
-	/* create symlink */
-	symlink = proc_symlink("jiffies_too", example_dir, 
-			       "jiffies");
-	if(symlink == NULL) {
-		rv = -ENOMEM;
-		goto no_symlink;
-	}
-
-	/* everything OK */
-	printk(KERN_INFO "%s %s initialised\n",
-	       MODULE_NAME, MODULE_VERS);
-	return 0;
-
-no_symlink:
-	remove_proc_entry("bar", example_dir);
-no_bar:
-	remove_proc_entry("foo", example_dir);
-no_foo:
-	remove_proc_entry("jiffies", example_dir);
-no_jiffies:			      
-	remove_proc_entry(MODULE_NAME, NULL);
-out:
-	return rv;
-}
-
-
-static void __exit cleanup_procfs_example(void)
-{
-	remove_proc_entry("jiffies_too", example_dir);
-	remove_proc_entry("bar", example_dir);
-	remove_proc_entry("foo", example_dir);
-	remove_proc_entry("jiffies", example_dir);
-	remove_proc_entry(MODULE_NAME, NULL);
-
-	printk(KERN_INFO "%s %s removed\n",
-	       MODULE_NAME, MODULE_VERS);
-}
-
-
-module_init(init_procfs_example);
-module_exit(cleanup_procfs_example);
-
-MODULE_AUTHOR("Erik Mouw");
-MODULE_DESCRIPTION("procfs examples");
-MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
thinkpad_acpi-convert-to-seq_file.patch
asus_acpi-convert-to-seq_file.patch
toshiba_acpi-convert-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
iseries-convert-to-proc_fops.patch
via-pmu-convert-to-proc_fops-seq_file.patch
proc_fops-convert-av7110.patch
proc_fops-convert-cpia.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix.patch
parisc-convert-proc-pdc-lcdled-to-seq_file.patch
mpt-fusion-convert-to-seq_file.patch
alpha-convert-srm-code-to-seq_file.patch
const-constify-remaining-dev_pm_ops.patch
uml-convert-to-seq_file-proc_fops.patch
uml-irq-register-race-condition.patch
make-debug_bugverbose-default-to-y.patch
proc-rename-de_get-to-pde_get-and-inline-it.patch
clps711xfb-convert-to-proc_fops.patch
pnpbios-convert-to-seq_file.patch
const-constify-remaining-pipe_buf_operations.patch
ufs-pass-qstr-instead-of-dentry-where-necessary-for-nfs.patch
ufs-nfs-support.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
proc-remove-docbook-and-example.patch

