From: akpm@linux-foundation.org
Subject: + kernel-doc-allow-structs-whose-members-are-all-private.patch added to -mm tree
Date: Wed, 17 Sep 2008 14:23:06 -0700
Message-ID: <200809172123.m8HLN6v5031066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754298AbYIQVYu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 17:24:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, hch@infradead.org, roland@redhat.com


The patch titled
     kernel-doc: allow structs whose members are all private
has been added to the -mm tree.  Its filename is
     kernel-doc-allow-structs-whose-members-are-all-private.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel-doc: allow structs whose members are all private
From: Randy Dunlap <randy.dunlap@oracle.com>

Struct members may be marked as private by using
	/* private: */
before them, as noted in Documentation/kernel-doc-nano-HOWTO.txt

Fix kernel-doc to handle structs whose members are all private;
otherwise invalid XML is generated:

xmlto: input does not validate (status 3)
linux-2.6.27-rc6-git4/Documentation/DocBook/debugobjects.xml:146: element variablelist: validity error : Element variablelist content does not follow the DTD, expecting ((title , titleabbrev?)? , varlistentry+), got ()
Document linux-2.6.27-rc6-git4/Documentation/DocBook/debugobjects.xml does not validate
make[1]: *** [Documentation/DocBook/debugobjects.html] Error 3

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Reported-by: Roland McGrath <roland@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN scripts/kernel-doc~kernel-doc-allow-structs-whose-members-are-all-private scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-allow-structs-whose-members-are-all-private
+++ a/scripts/kernel-doc
@@ -781,6 +781,7 @@ sub output_struct_xml(%) {
     print " <refsect1>\n";
     print "  <title>Members</title>\n";
 
+    if ($#{$args{'parameterlist'}} >= 0) {
     print "  <variablelist>\n";
     foreach $parameter (@{$args{'parameterlist'}}) {
       ($parameter =~ /^#/) && next;
@@ -798,6 +799,9 @@ sub output_struct_xml(%) {
       print "    </varlistentry>\n";
     }
     print "  </variablelist>\n";
+    } else {
+	print " <para>\n  None\n </para>\n";
+    }
     print " </refsect1>\n";
 
     output_section_xml(@_);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

kernel-doc-allow-structs-whose-members-are-all-private.patch
linux-next.patch
mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch
fb-metronome-printk-format-warning.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
dontdiff-more-updates-to-be-closer-to-gitignore.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

