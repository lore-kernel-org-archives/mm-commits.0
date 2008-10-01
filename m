From: akpm@linux-foundation.org
Subject: - kernel-doc-allow-structs-whose-members-are-all-private.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:49:49 -0700
Message-ID: <200810012149.m91LnnPJ005721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753640AbYJAVuo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:50:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, hch@infradead.org, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: allow structs whose members are all private
has been removed from the -mm tree.  Its filename was
     kernel-doc-allow-structs-whose-members-are-all-private.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-x86.patch
git-ftrace.patch
git-hid.patch
git-acpi.patch
git-net.patch
git-sound.patch
git-block.patch
git-slab.patch
git-drm.patch
git-security-testing.patch
git-fastboot.patch
mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch
fb-metronome-printk-format-warning.patch
toshiba_acpi-depends-on-input.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
drivers-net-hp-plusc-fix-build-error.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
eeepc-laptop-use-standard-interfaces-fix.patch
eeepc-laptop-use-standard-interfaces-fix-fix.patch
dontdiff-more-updates-to-be-closer-to-gitignore.patch
w1-documentation-w1-masters-ds2490-update.patch
configure-out-aio-support-fix.patch
profile-likely-unlikely-macros.patch

