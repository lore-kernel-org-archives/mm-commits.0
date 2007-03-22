From: akpm@linux-foundation.org
Subject: + ipwireless-use-ansi-func-decl.patch added to -mm tree
Date: Wed, 21 Mar 2007 22:17:15 -0800
Message-ID: <200703220617.l2M6HFqi013759@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40854 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbXCVGRY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 02:17:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, jkosina@suse.cz


The patch titled
     ipwireless: use ANSI func. decl.
has been added to the -mm tree.  Its filename is
     ipwireless-use-ansi-func-decl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ipwireless: use ANSI func. decl.
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix function declaration:
drivers/char/pcmcia/ipwireless_cs_tty.c:730:29: warning: non-ANSI function declaration of function 'ipwireless_tty_release'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pcmcia/ipwireless_cs_tty.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/pcmcia/ipwireless_cs_tty.c~ipwireless-use-ansi-func-decl drivers/char/pcmcia/ipwireless_cs_tty.c
--- a/drivers/char/pcmcia/ipwireless_cs_tty.c~ipwireless-use-ansi-func-decl
+++ a/drivers/char/pcmcia/ipwireless_cs_tty.c
@@ -727,7 +727,7 @@ int ipwireless_tty_init(int major)
 	return 0;
 }
 
-void ipwireless_tty_release()
+void ipwireless_tty_release(void)
 {
 	int ret, loops = 0;
 	remove_proc_entry(IPWIRELESS_PCCARD_NAME, &proc_root);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-drm.patch
git-libata-all.patch
romfs-printk-format-warnings.patch
git-netdev-all.patch
fusion-kernel-doc-warning-fixes.patch
unionfs-sioq-not-__exit.patch
i386-fix-gdts-number-of-quadwords-in.patch
scripts-kernel-doc-whitespace-cleanup.patch
reiserfs-proc-support-requires-proc_fs.patch
kprobes-fix-sparse-null-warning.patch
ptrace-needs-proc_fs.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
profile-likely-unlikely-macros.patch
ipwireless-use-ansi-func-decl.patch
cpuidle-unsigned-bitfield.patch
acpi-dock-use-null-for-pointer.patch
ext4-use-null-for-pointers.patch
nozomi-use-null-for-pointers.patch
