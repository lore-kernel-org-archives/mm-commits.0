From: akpm@linux-foundation.org
Subject: + xfrm4-fix-build-when-sysctls-are-disabled.patch added to -mm tree
Date: Wed, 05 Aug 2009 17:31:06 -0700
Message-ID: <200908060031.n760V6iu028127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752400AbZHFAbK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2009 20:31:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     xfrm4: fix build when SYSCTLs are disabled
has been added to the -mm tree.  Its filename is
     xfrm4-fix-build-when-sysctls-are-disabled.patch

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
Subject: xfrm4: fix build when SYSCTLs are disabled
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors when SYSCTLs are not enabled:
(.init.text+0x5154): undefined reference to `net_ipv4_ctl_path'
(.init.text+0x5176): undefined reference to `register_net_sysctl_table'
xfrm4_policy.c:(.exit.text+0x573): undefined reference to `unregister_net_sysctl_table

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/xfrm4_policy.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN net/ipv4/xfrm4_policy.c~xfrm4-fix-build-when-sysctls-are-disabled net/ipv4/xfrm4_policy.c
--- a/net/ipv4/xfrm4_policy.c~xfrm4-fix-build-when-sysctls-are-disabled
+++ a/net/ipv4/xfrm4_policy.c
@@ -264,6 +264,7 @@ static struct xfrm_policy_afinfo xfrm4_p
 	.fill_dst =		xfrm4_fill_dst,
 };
 
+#ifdef CONFIG_SYSCTL
 static struct ctl_table xfrm4_policy_table[] = {
 	{
 		.ctl_name       = CTL_UNNUMBERED,
@@ -277,6 +278,7 @@ static struct ctl_table xfrm4_policy_tab
 };
 
 static struct ctl_table_header *sysctl_hdr;
+#endif
 
 static void __init xfrm4_policy_init(void)
 {
@@ -285,8 +287,10 @@ static void __init xfrm4_policy_init(voi
 
 static void __exit xfrm4_policy_fini(void)
 {
+#ifdef CONFIG_SYSCTL
 	if (sysctl_hdr)
 		unregister_net_sysctl_table(sysctl_hdr);
+#endif
 	xfrm_policy_unregister_afinfo(&xfrm4_policy_afinfo);
 }
 
@@ -305,7 +309,9 @@ void __init xfrm4_init(int rt_max_size)
 	 * and start cleaning when were 1/2 full
 	 */
 	xfrm4_dst_ops.gc_thresh = rt_max_size/2;
+#ifdef CONFIG_SYSCTL
 	sysctl_hdr = register_net_sysctl_table(&init_net, net_ipv4_ctl_path,
 						xfrm4_policy_table);
+#endif
 }
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
media-zr364xx-fix-build-errors.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
kernel-hacking-move-strip_asm_syms-from-general.patch
staging-udlfb-fix-printk-format-warning.patch
xfrm4-fix-build-when-sysctls-are-disabled.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
page_alloc-fix-kernel-doc-warning.patch
ksm-add-some-documentation.patch
ummunotify-userspace-support-for-mmu-notifications-v3-fix-fix.patch
add-a-driver-for-the-winbond-wpcd376i-ir-functionality-select-bitreverse.patch
lis3-add-power-management-functions-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
spih-add-missing-kernel-doc-for-struct-spi_master.patch
gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix.patch
doc-filesystems-remove-smount-program.patch
doc-filesystems-more-mount-cleanups.patch
documentation-update-stale-definition-of-file-nr-in-fstxt.patch
reiser4-export-remove_from_page_cache-fix.patch

