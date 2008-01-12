From: akpm@linux-foundation.org
Subject: + sysfs-make-sysfs_deprecated-depend-on-sysfs.patch added to -mm tree
Date: Fri, 11 Jan 2008 17:46:39 -0800
Message-ID: <200801120146.m0C1kdnR008440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57241 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756021AbYALBqw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 20:46:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, greg@kroah.com, kay.sievers@vrfy.org, sam@ravnborg.org


The patch titled
     sysfs: make SYSFS_DEPRECATED depend on SYSFS
has been added to the -mm tree.  Its filename is
     sysfs-make-sysfs_deprecated-depend-on-sysfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysfs: make SYSFS_DEPRECATED depend on SYSFS
From: Randy Dunlap <randy.dunlap@oracle.com>

Make SYSFS_DEPRECATED depend on SYSFS since files that check
CONFIG_SYSFS_DEPRECATED don't check for CONFIG_SYSFS first.  Also don't
prompt user about SYSFS_DEPRECATED if SYSFS=n.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN init/Kconfig~sysfs-make-sysfs_deprecated-depend-on-sysfs init/Kconfig
--- a/init/Kconfig~sysfs-make-sysfs_deprecated-depend-on-sysfs
+++ a/init/Kconfig
@@ -363,6 +363,7 @@ config CGROUP_CPUACCT
 
 config SYSFS_DEPRECATED
 	bool "Create deprecated sysfs files"
+	depends on SYSFS
 	default y
 	help
 	  This option creates deprecated symlinks such as the
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

scsi-qla2xxx-qla_osc-section-fix.patch
cciss-section-mismatch.patch
advansys-fix-section-mismatch-warning.patch
uvesafb-fix-section-mismatch-warnings.patch
driver-core-build-with-sysfs=n.patch
sysfs-make-sysfs_deprecated-depend-on-sysfs.patch
git-dvb.patch
dvb-av7110-fix-section-mismatch.patch
git-kbuild.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-scsi-misc.patch
megaraid-fix-section-mismatch.patch
git-unionfs.patch
hostap-section-mismatch-warning.patch
git-ipwireless_cs.patch
git-x86.patch
x86-discover_ebda-section-mismatch.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
dio-fix-kernel-doc-notation.patch
tpm-infineon-section-mismatch.patch
tdfxfb-fix-section-mismatch-warnings.patch
uvesafb-small-cleanups.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
