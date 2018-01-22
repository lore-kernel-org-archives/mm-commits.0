From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 22 Jan 2018 12:10:35 -0800
Message-ID: <20180122201035.5NGza7PfQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58562 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750892AbeAVUKg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Jan 2018 15:10:36 -0500
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

 Documentation/virtual/kvm/api.txt    |   97 -------------------------
 arch/powerpc/kernel/setup-common.c   |    4 -
 drivers/gpu/drm/i915/intel_display.c |   58 --------------
 drivers/i2c/i2c-core-smbus.c         |    3 
 drivers/net/tun.c                    |    4 -
 5 files changed, 166 deletions(-)

diff -puN arch/powerpc/kernel/setup-common.c~linux-next-git-rejects arch/powerpc/kernel/setup-common.c
--- a/arch/powerpc/kernel/setup-common.c~linux-next-git-rejects
+++ a/arch/powerpc/kernel/setup-common.c
@@ -347,10 +347,6 @@ static int show_cpuinfo(struct seq_file
 		   (loops_per_jiffy / (5000/HZ)) % 100);
 #endif
 	seq_printf(m, "\n");
-<<<<<<< HEAD
-#endif
-=======
->>>>>>> linux-next/akpm-base
 	/* If this is the last cpu, print the summary */
 	if (cpumask_next(cpu_id, cpu_online_mask) >= nr_cpu_ids)
 		show_cpuinfo_summary(m);
diff -puN Documentation/virtual/kvm/api.txt~linux-next-git-rejects Documentation/virtual/kvm/api.txt
--- a/Documentation/virtual/kvm/api.txt~linux-next-git-rejects
+++ a/Documentation/virtual/kvm/api.txt
@@ -3404,103 +3404,6 @@ invalid, if invalid pages are written to
 or if no page table is present for the addresses (e.g. when using
 hugepages).
 
-<<<<<<< HEAD
-4.108 KVM_PPC_GET_CPU_CHAR
-
-Capability: KVM_CAP_PPC_GET_CPU_CHAR
-Architectures: powerpc
-Type: vm ioctl
-Parameters: struct kvm_ppc_cpu_char (out)
-Returns: 0 on successful completion
-	 -EFAULT if struct kvm_ppc_cpu_char cannot be written
-
-This ioctl gives userspace information about certain characteristics
-of the CPU relating to speculative execution of instructions and
-possible information leakage resulting from speculative execution (see
-CVE-2017-5715, CVE-2017-5753 and CVE-2017-5754).  The information is
-returned in struct kvm_ppc_cpu_char, which looks like this:
-
-struct kvm_ppc_cpu_char {
-	__u64	character;		/* characteristics of the CPU */
-	__u64	behaviour;		/* recommended software behaviour */
-	__u64	character_mask;		/* valid bits in character */
-	__u64	behaviour_mask;		/* valid bits in behaviour */
-};
-
-For extensibility, the character_mask and behaviour_mask fields
-indicate which bits of character and behaviour have been filled in by
-the kernel.  If the set of defined bits is extended in future then
-userspace will be able to tell whether it is running on a kernel that
-knows about the new bits.
-
-The character field describes attributes of the CPU which can help
-with preventing inadvertent information disclosure - specifically,
-whether there is an instruction to flash-invalidate the L1 data cache
-(ori 30,30,0 or mtspr SPRN_TRIG2,rN), whether the L1 data cache is set
-to a mode where entries can only be used by the thread that created
-them, whether the bcctr[l] instruction prevents speculation, and
-whether a speculation barrier instruction (ori 31,31,0) is provided.
-
-The behaviour field describes actions that software should take to
-prevent inadvertent information disclosure, and thus describes which
-vulnerabilities the hardware is subject to; specifically whether the
-L1 data cache should be flushed when returning to user mode from the
-kernel, and whether a speculation barrier should be placed between an
-array bounds check and the array access.
-
-These fields use the same bit definitions as the new
-H_GET_CPU_CHARACTERISTICS hypercall.
-=======
-4.109 KVM_MEMORY_ENCRYPT_OP
-
-Capability: basic
-Architectures: x86
-Type: system
-Parameters: an opaque platform specific structure (in/out)
-Returns: 0 on success; -1 on error
-
-If the platform supports creating encrypted VMs then this ioctl can be used
-for issuing platform-specific memory encryption commands to manage those
-encrypted VMs.
-
-Currently, this ioctl is used for issuing Secure Encrypted Virtualization
-(SEV) commands on AMD Processors. The SEV commands are defined in
-Documentation/virtual/kvm/amd-memory-encryption.txt.
-
-4.110 KVM_MEMORY_ENCRYPT_REG_REGION
-
-Capability: basic
-Architectures: x86
-Type: system
-Parameters: struct kvm_enc_region (in)
-Returns: 0 on success; -1 on error
-
-This ioctl can be used to register a guest memory region which may
-contain encrypted data (e.g. guest RAM, SMRAM etc).
-
-It is used in the SEV-enabled guest. When encryption is enabled, a guest
-memory region may contain encrypted data. The SEV memory encryption
-engine uses a tweak such that two identical plaintext pages, each at
-different locations will have differing ciphertexts. So swapping or
-moving ciphertext of those pages will not result in plaintext being
-swapped. So relocating (or migrating) physical backing pages for the SEV
-guest will require some additional steps.
-
-Note: The current SEV key management spec does not provide commands to
-swap or migrate (move) ciphertext pages. Hence, for now we pin the guest
-memory region registered with the ioctl.
-
-4.111 KVM_MEMORY_ENCRYPT_UNREG_REGION
-
-Capability: basic
-Architectures: x86
-Type: system
-Parameters: struct kvm_enc_region (in)
-Returns: 0 on success; -1 on error
-
-This ioctl can be used to unregister the guest memory region registered
-with KVM_MEMORY_ENCRYPT_REG_REGION ioctl above.
->>>>>>> linux-next/akpm-base
 
 5. The kvm_run structure
 ------------------------
diff -puN drivers/gpu/drm/i915/intel_display.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_display.c
--- a/drivers/gpu/drm/i915/intel_display.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_display.c
@@ -3296,22 +3296,12 @@ static void i9xx_disable_plane(struct in
 	spin_unlock_irqrestore(&dev_priv->uncore.lock, irqflags);
 }
 
-<<<<<<< HEAD
-static bool i9xx_plane_get_hw_state(struct intel_plane *primary)
-{
-
-	struct drm_i915_private *dev_priv = to_i915(primary->base.dev);
-	enum intel_display_power_domain power_domain;
-	enum plane plane = primary->plane;
-	enum pipe pipe = primary->pipe;
-=======
 static bool i9xx_plane_get_hw_state(struct intel_plane *plane)
 {
 	struct drm_i915_private *dev_priv = to_i915(plane->base.dev);
 	enum intel_display_power_domain power_domain;
 	enum i9xx_plane_id i9xx_plane = plane->i9xx_plane;
 	enum pipe pipe = plane->pipe;
->>>>>>> linux-next/akpm-base
 	bool ret;
 
 	/*
@@ -3323,11 +3313,7 @@ static bool i9xx_plane_get_hw_state(stru
 	if (!intel_display_power_get_if_enabled(dev_priv, power_domain))
 		return false;
 
-<<<<<<< HEAD
-	ret = I915_READ(DSPCNTR(plane)) & DISPLAY_PLANE_ENABLE;
-=======
 	ret = I915_READ(DSPCNTR(i9xx_plane)) & DISPLAY_PLANE_ENABLE;
->>>>>>> linux-next/akpm-base
 
 	intel_display_power_put(dev_priv, power_domain);
 
@@ -4869,11 +4855,6 @@ void hsw_enable_ips(const struct intel_c
 	 */
 	WARN_ON(!(crtc_state->active_planes & ~BIT(PLANE_CURSOR)));
 
-<<<<<<< HEAD
-	assert_plane_enabled(to_intel_plane(crtc->base.primary));
-
-=======
->>>>>>> linux-next/akpm-base
 	if (IS_BROADWELL(dev_priv)) {
 		mutex_lock(&dev_priv->pcu_lock);
 		WARN_ON(sandybridge_pcode_write(dev_priv, DISPLAY_IPS_CONTROL,
@@ -4907,11 +4888,6 @@ void hsw_disable_ips(const struct intel_
 	if (!crtc_state->ips_enabled)
 		return;
 
-<<<<<<< HEAD
-	assert_plane_enabled(to_intel_plane(crtc->base.primary));
-
-=======
->>>>>>> linux-next/akpm-base
 	if (IS_BROADWELL(dev_priv)) {
 		mutex_lock(&dev_priv->pcu_lock);
 		WARN_ON(sandybridge_pcode_write(dev_priv, DISPLAY_IPS_CONTROL, 0));
@@ -13204,26 +13180,16 @@ intel_primary_plane_create(struct drm_i9
 		num_formats = ARRAY_SIZE(i965_primary_formats);
 		modifiers = i9xx_format_modifiers;
 
-<<<<<<< HEAD
-		primary->update_plane = i9xx_update_primary_plane;
-		primary->disable_plane = i9xx_disable_primary_plane;
-=======
 		primary->update_plane = i9xx_update_plane;
 		primary->disable_plane = i9xx_disable_plane;
->>>>>>> linux-next/akpm-base
 		primary->get_hw_state = i9xx_plane_get_hw_state;
 	} else {
 		intel_primary_formats = i8xx_primary_formats;
 		num_formats = ARRAY_SIZE(i8xx_primary_formats);
 		modifiers = i9xx_format_modifiers;
 
-<<<<<<< HEAD
-		primary->update_plane = i9xx_update_primary_plane;
-		primary->disable_plane = i9xx_disable_primary_plane;
-=======
 		primary->update_plane = i9xx_update_plane;
 		primary->disable_plane = i9xx_disable_plane;
->>>>>>> linux-next/akpm-base
 		primary->get_hw_state = i9xx_plane_get_hw_state;
 	}
 
@@ -14713,38 +14679,15 @@ void i830_disable_pipe(struct drm_i915_p
 }
 
 static bool intel_plane_mapping_ok(struct intel_crtc *crtc,
-<<<<<<< HEAD
-				   struct intel_plane *primary)
-{
-	struct drm_i915_private *dev_priv = to_i915(crtc->base.dev);
-	enum plane plane = primary->plane;
-	u32 val = I915_READ(DSPCNTR(plane));
-=======
 				   struct intel_plane *plane)
 {
 	struct drm_i915_private *dev_priv = to_i915(crtc->base.dev);
 	enum i9xx_plane_id i9xx_plane = plane->i9xx_plane;
 	u32 val = I915_READ(DSPCNTR(i9xx_plane));
->>>>>>> linux-next/akpm-base
 
 	return (val & DISPLAY_PLANE_ENABLE) == 0 ||
 		(val & DISPPLANE_SEL_PIPE_MASK) == DISPPLANE_SEL_PIPE(crtc->pipe);
 }
-<<<<<<< HEAD
-
-static void
-intel_sanitize_plane_mapping(struct drm_i915_private *dev_priv)
-{
-	struct intel_crtc *crtc;
-
-	if (INTEL_GEN(dev_priv) >= 4)
-		return;
-
-	for_each_intel_crtc(&dev_priv->drm, crtc) {
-		struct intel_plane *plane =
-			to_intel_plane(crtc->base.primary);
-
-=======
 
 static void
 intel_sanitize_plane_mapping(struct drm_i915_private *dev_priv)
@@ -14758,7 +14701,6 @@ intel_sanitize_plane_mapping(struct drm_
 		struct intel_plane *plane =
 			to_intel_plane(crtc->base.primary);
 
->>>>>>> linux-next/akpm-base
 		if (intel_plane_mapping_ok(crtc, plane))
 			continue;
 
diff -puN drivers/i2c/i2c-core-smbus.c~linux-next-git-rejects drivers/i2c/i2c-core-smbus.c
--- a/drivers/i2c/i2c-core-smbus.c~linux-next-git-rejects
+++ a/drivers/i2c/i2c-core-smbus.c
@@ -433,10 +433,7 @@ static s32 i2c_smbus_xfer_emulated(struc
 			i2c_smbus_try_get_dmabuf(&msg[1], 0);
 		} else {
 			msg[0].len = data->block[0] + 1;
-<<<<<<< HEAD
-=======
 			i2c_smbus_try_get_dmabuf(&msg[0], command);
->>>>>>> linux-next/akpm-base
 			for (i = 1; i <= data->block[0]; i++)
 				msg[0].buf[i] = data->block[i];
 		}
diff -puN drivers/net/tun.c~linux-next-git-rejects drivers/net/tun.c
--- a/drivers/net/tun.c~linux-next-git-rejects
+++ a/drivers/net/tun.c
@@ -733,14 +733,10 @@ static void __tun_detach(struct tun_file
 			    tun->dev->reg_state == NETREG_REGISTERED)
 				unregister_netdevice(tun->dev);
 		}
-<<<<<<< HEAD
-		tun_cleanup_tx_array(tfile);
-=======
 		if (tun) {
 			ptr_ring_cleanup(&tfile->tx_ring, tun_ptr_free);
 			xdp_rxq_info_unreg(&tfile->xdp_rxq);
 		}
->>>>>>> linux-next/akpm-base
 		sock_put(&tfile->sk);
 	}
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch
mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch
mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch
mm-page_owner-clean-up-init_pages_in_zone-v3-fix.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-fix.patch
kasan-clean-up-kasan_shadow_scale_shift-usage-checkpatch-fixes.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
fs-crypto-hooksc-fix-build-with-gcc-444.patch
include-linux-mtd-rawnandh-fix-build-with-gcc-444.patch
net-sched-sch_prioc-work-around-gcc-444-union-initializer-issues.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

