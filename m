From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 18 Aug 2016 14:01:45 -0700
Message-ID: <57b62239.T1f95qlxMoKuwclj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51734 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754020AbcHSC5g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Aug 2016 22:57:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/dsa/mv88e6xxx/chip.c           |   31 -------------------
 drivers/net/ethernet/qlogic/qed/qed_dcbx.c |   19 -----------
 kernel/bpf/verifier.c                      |    7 ----
 net/mac80211/driver-ops.h                  |    6 ---
 4 files changed, 63 deletions(-)

diff -puN drivers/net/dsa/mv88e6xxx/chip.c~linux-next-git-rejects drivers/net/dsa/mv88e6xxx/chip.c
--- a/drivers/net/dsa/mv88e6xxx/chip.c~linux-next-git-rejects
+++ a/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3250,37 +3250,6 @@ static int mv88e6xxx_set_addr(struct dsa
 	return err;
 }
 
-<<<<<<< HEAD
-#ifdef CONFIG_NET_DSA_HWMON
-static int mv88e6xxx_mdio_page_read(struct dsa_switch *ds, int port, int page,
-				    int reg)
-{
-	struct mv88e6xxx_chip *chip = ds_to_priv(ds);
-	int ret;
-
-	mutex_lock(&chip->reg_lock);
-	ret = _mv88e6xxx_mdio_page_read(chip, port, page, reg);
-	mutex_unlock(&chip->reg_lock);
-
-	return ret;
-}
-
-static int mv88e6xxx_mdio_page_write(struct dsa_switch *ds, int port, int page,
-				     int reg, int val)
-{
-	struct mv88e6xxx_chip *chip = ds_to_priv(ds);
-	int ret;
-
-	mutex_lock(&chip->reg_lock);
-	ret = _mv88e6xxx_mdio_page_write(chip, port, page, reg, val);
-	mutex_unlock(&chip->reg_lock);
-
-	return ret;
-}
-#endif
-
-=======
->>>>>>> linux-next/akpm-base
 static int mv88e6xxx_port_to_mdio_addr(struct mv88e6xxx_chip *chip, int port)
 {
 	if (port >= 0 && port < chip->info->num_ports)
diff -puN drivers/net/ethernet/qlogic/qed/qed_dcbx.c~linux-next-git-rejects drivers/net/ethernet/qlogic/qed/qed_dcbx.c
--- a/drivers/net/ethernet/qlogic/qed/qed_dcbx.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
@@ -115,7 +115,6 @@ static bool qed_dcbx_fcoe_tlv(u32 app_in
 		ethtype = qed_dcbx_app_ethtype(app_info_bitmap);
 
 	return !!(ethtype && (proto_id == QED_ETH_TYPE_FCOE));
-<<<<<<< HEAD
 }
 
 static bool qed_dcbx_roce_tlv(u32 app_info_bitmap, u16 proto_id, bool ieee)
@@ -132,24 +131,6 @@ static bool qed_dcbx_roce_tlv(u32 app_in
 
 static bool qed_dcbx_roce_v2_tlv(u32 app_info_bitmap, u16 proto_id, bool ieee)
 {
-=======
-}
-
-static bool qed_dcbx_roce_tlv(u32 app_info_bitmap, u16 proto_id, bool ieee)
-{
-	bool ethtype;
-
-	if (ieee)
-		ethtype = qed_dcbx_ieee_app_ethtype(app_info_bitmap);
-	else
-		ethtype = qed_dcbx_app_ethtype(app_info_bitmap);
-
-	return !!(ethtype && (proto_id == QED_ETH_TYPE_ROCE));
-}
-
-static bool qed_dcbx_roce_v2_tlv(u32 app_info_bitmap, u16 proto_id, bool ieee)
-{
->>>>>>> linux-next/akpm-base
 	bool port;
 
 	if (ieee)
diff -puN kernel/bpf/verifier.c~linux-next-git-rejects kernel/bpf/verifier.c
--- a/kernel/bpf/verifier.c~linux-next-git-rejects
+++ a/kernel/bpf/verifier.c
@@ -1078,12 +1078,8 @@ static int check_map_func_compatibility(
 			goto error;
 		break;
 	case BPF_MAP_TYPE_CGROUP_ARRAY:
-<<<<<<< HEAD
-		if (func_id != BPF_FUNC_skb_under_cgroup)
-=======
 		if (func_id != BPF_FUNC_skb_under_cgroup &&
 		    func_id != BPF_FUNC_current_task_under_cgroup)
->>>>>>> linux-next/akpm-base
 			goto error;
 		break;
 	default:
@@ -1105,10 +1101,7 @@ static int check_map_func_compatibility(
 		if (map->map_type != BPF_MAP_TYPE_STACK_TRACE)
 			goto error;
 		break;
-<<<<<<< HEAD
-=======
 	case BPF_FUNC_current_task_under_cgroup:
->>>>>>> linux-next/akpm-base
 	case BPF_FUNC_skb_under_cgroup:
 		if (map->map_type != BPF_MAP_TYPE_CGROUP_ARRAY)
 			goto error;
diff -puN net/mac80211/driver-ops.h~linux-next-git-rejects net/mac80211/driver-ops.h
--- a/net/mac80211/driver-ops.h~linux-next-git-rejects
+++ a/net/mac80211/driver-ops.h
@@ -1092,15 +1092,9 @@ static inline u32 drv_get_expected_throu
 {
 	u32 ret = 0;
 
-<<<<<<< HEAD
-	trace_drv_get_expected_throughput(sta);
-	if (local->ops->get_expected_throughput)
-		ret = local->ops->get_expected_throughput(&local->hw, sta);
-=======
 	trace_drv_get_expected_throughput(&sta->sta);
 	if (local->ops->get_expected_throughput && sta->uploaded)
 		ret = local->ops->get_expected_throughput(&local->hw, &sta->sta);
->>>>>>> linux-next/akpm-base
 	trace_drv_return_u32(local, ret);
 
 	return ret;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

