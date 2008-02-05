From: akpm@linux-foundation.org
Subject: - hamradio-fix-dmascc-section-mismatch.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:39:27 -0800
Message-ID: <200802052239.m15Md8aD013023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36433 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762069AbYBEWni (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, klaus.kudielka@gmx.net, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     hamradio: fix dmascc section mismatch
has been removed from the -mm tree.  Its filename was
     hamradio-fix-dmascc-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hamradio: fix dmascc section mismatch
From: Randy Dunlap <randy.dunlap@oracle.com>

hw[] is used in both init and exit functions so it cannot be initdata (section
mismatch is when CONFIG_MODULES=n and CONFIG_DMASCC=y).

WARNING: vmlinux.o(.exit.text+0xba7): Section mismatch: reference to .init.data: (between 'dmascc_exit' and 'sixpack_exit_driver')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Klaus Kudielka <klaus.kudielka@gmx.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/hamradio/dmascc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/hamradio/dmascc.c~hamradio-fix-dmascc-section-mismatch drivers/net/hamradio/dmascc.c
--- a/drivers/net/hamradio/dmascc.c~hamradio-fix-dmascc-section-mismatch
+++ a/drivers/net/hamradio/dmascc.c
@@ -262,8 +262,8 @@ static void tm_isr(struct scc_priv *priv
 
 static int io[MAX_NUM_DEVS] __initdata = { 0, };
 
-/* Beware! hw[] is also used in cleanup_module(). */
-static struct scc_hardware hw[NUM_TYPES] __initdata_or_module = HARDWARE;
+/* Beware! hw[] is also used in dmascc_exit(). */
+static struct scc_hardware hw[NUM_TYPES] = HARDWARE;
 
 
 /* Global variables */
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
tpm-infineon-section-mismatch.patch
tdfxfb-fix-section-mismatch-warnings.patch
uvesafb-small-cleanups.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
kernel-doc-prevent-duplicate-description-output.patch
kernel-doc-warn-on-badly-formatted-short-description.patch
email-clientstxt-sylpheed-is-ok-at-imap.patch
fs-menu-small-reorg.patch
the-scheduled-time-option-removal.patch
getdelays-fix-gcc-warnings.patch
profile-likely-unlikely-macros.patch
