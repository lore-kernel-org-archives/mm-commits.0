From: akpm@linux-foundation.org
Subject: + mmc-add-enable-and-disable-methods-to-mmc-host.patch added to -mm tree
Date: Fri, 24 Jul 2009 15:54:27 -0700
Message-ID: <200907242254.n6OMsSqe030711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751856AbZGXWyk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Jul 2009 18:54:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, matt@console-pimps.org, pierre@ossman.eu, roberto.foglietta@gmail.com


The patch titled
     mmc: add 'enable' and 'disable' methods to mmc host
has been added to the -mm tree.  Its filename is
     mmc-add-enable-and-disable-methods-to-mmc-host.patch

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
Subject: mmc: add 'enable' and 'disable' methods to mmc host
From: Adrian Hunter <adrian.hunter@nokia.com>

MMC hosts that support power saving can use the 'enable' and 'disable'
methods to exit and enter power saving states.  An explanation of their
use is provided in the comments added to include/linux/mmc/host.h.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c  |  174 +++++++++++++++++++++++++++++++++++--
 drivers/mmc/core/host.c  |    1 
 drivers/mmc/core/host.h  |    2 
 include/linux/mmc/host.h |   47 +++++++++
 4 files changed, 218 insertions(+), 6 deletions(-)

diff -puN drivers/mmc/core/core.c~mmc-add-enable-and-disable-methods-to-mmc-host drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-add-enable-and-disable-methods-to-mmc-host
+++ a/drivers/mmc/core/core.c
@@ -344,6 +344,98 @@ unsigned int mmc_align_data_size(struct 
 EXPORT_SYMBOL(mmc_align_data_size);
 
 /**
+ *	mmc_host_enable - enable a host.
+ *	@host: mmc host to enable
+ *
+ *	Hosts that support power saving can use the 'enable' and 'disable'
+ *	methods to exit and enter power saving states. For more information
+ *	see comments for struct mmc_host_ops.
+ */
+int mmc_host_enable(struct mmc_host *host)
+{
+	if (!(host->caps & MMC_CAP_DISABLE))
+		return 0;
+
+	if (host->en_dis_recurs)
+		return 0;
+
+	if (host->nesting_cnt++)
+		return 0;
+
+	cancel_delayed_work_sync(&host->disable);
+
+	if (host->enabled)
+		return 0;
+
+	if (host->ops->enable) {
+		int err;
+
+		host->en_dis_recurs = 1;
+		err = host->ops->enable(host);
+		host->en_dis_recurs = 0;
+
+		if (err) {
+			pr_debug("%s: enable error %d\n",
+				 mmc_hostname(host), err);
+			return err;
+		}
+	}
+	host->enabled = 1;
+	return 0;
+}
+EXPORT_SYMBOL(mmc_host_enable);
+
+static int mmc_host_do_disable(struct mmc_host *host, int lazy)
+{
+	if (host->ops->disable) {
+		int err;
+
+		host->en_dis_recurs = 1;
+		err = host->ops->disable(host, lazy);
+		host->en_dis_recurs = 0;
+
+		if (err < 0) {
+			pr_debug("%s: disable error %d\n",
+				 mmc_hostname(host), err);
+			return err;
+		}
+		if (err > 0)
+			mmc_schedule_delayed_work(&host->disable, err);
+	}
+	host->enabled = 0;
+	return 0;
+}
+
+/**
+ *	mmc_host_disable - disable a host.
+ *	@host: mmc host to disable
+ *
+ *	Hosts that support power saving can use the 'enable' and 'disable'
+ *	methods to exit and enter power saving states. For more information
+ *	see comments for struct mmc_host_ops.
+ */
+int mmc_host_disable(struct mmc_host *host)
+{
+	int err;
+
+	if (!(host->caps & MMC_CAP_DISABLE))
+		return 0;
+
+	if (host->en_dis_recurs)
+		return 0;
+
+	if (--host->nesting_cnt)
+		return 0;
+
+	if (!host->enabled)
+		return 0;
+
+	err = mmc_host_do_disable(host, 0);
+	return err;
+}
+EXPORT_SYMBOL(mmc_host_disable);
+
+/**
  *	__mmc_claim_host - exclusively claim a host
  *	@host: mmc host to claim
  *	@abort: whether or not the operation should be aborted
@@ -379,11 +471,81 @@ int __mmc_claim_host(struct mmc_host *ho
 		wake_up(&host->wq);
 	spin_unlock_irqrestore(&host->lock, flags);
 	remove_wait_queue(&host->wq, &wait);
+	if (!stop)
+		mmc_host_enable(host);
 	return stop;
 }
 
 EXPORT_SYMBOL(__mmc_claim_host);
 
+static int mmc_try_claim_host(struct mmc_host *host)
+{
+	int claimed_host = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->lock, flags);
+	if (!host->claimed) {
+		host->claimed = 1;
+		claimed_host = 1;
+	}
+	spin_unlock_irqrestore(&host->lock, flags);
+	return claimed_host;
+}
+
+static void mmc_do_release_host(struct mmc_host *host)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->lock, flags);
+	host->claimed = 0;
+	spin_unlock_irqrestore(&host->lock, flags);
+
+	wake_up(&host->wq);
+}
+
+void mmc_host_deeper_disable(struct work_struct *work)
+{
+	struct mmc_host *host =
+		container_of(work, struct mmc_host, disable.work);
+
+	/* If the host is claimed then we do not want to disable it anymore */
+	if (!mmc_try_claim_host(host))
+		return;
+	mmc_host_do_disable(host, 1);
+	mmc_do_release_host(host);
+}
+
+/**
+ *	mmc_host_lazy_disable - lazily disable a host.
+ *	@host: mmc host to disable
+ *
+ *	Hosts that support power saving can use the 'enable' and 'disable'
+ *	methods to exit and enter power saving states. For more information
+ *	see comments for struct mmc_host_ops.
+ */
+int mmc_host_lazy_disable(struct mmc_host *host)
+{
+	if (!(host->caps & MMC_CAP_DISABLE))
+		return 0;
+
+	if (host->en_dis_recurs)
+		return 0;
+
+	if (--host->nesting_cnt)
+		return 0;
+
+	if (!host->enabled)
+		return 0;
+
+	if (host->disable_delay) {
+		mmc_schedule_delayed_work(&host->disable,
+				msecs_to_jiffies(host->disable_delay));
+		return 0;
+	} else
+		return mmc_host_do_disable(host, 1);
+}
+EXPORT_SYMBOL(mmc_host_lazy_disable);
+
 /**
  *	mmc_release_host - release a host
  *	@host: mmc host to release
@@ -393,15 +555,11 @@ EXPORT_SYMBOL(__mmc_claim_host);
  */
 void mmc_release_host(struct mmc_host *host)
 {
-	unsigned long flags;
-
 	WARN_ON(!host->claimed);
 
-	spin_lock_irqsave(&host->lock, flags);
-	host->claimed = 0;
-	spin_unlock_irqrestore(&host->lock, flags);
+	mmc_host_lazy_disable(host);
 
-	wake_up(&host->wq);
+	mmc_do_release_host(host);
 }
 
 EXPORT_SYMBOL(mmc_release_host);
@@ -953,6 +1111,8 @@ void mmc_stop_host(struct mmc_host *host
 	spin_unlock_irqrestore(&host->lock, flags);
 #endif
 
+	if (host->caps & MMC_CAP_DISABLE)
+		cancel_delayed_work(&host->disable);
 	cancel_delayed_work(&host->detect);
 	mmc_flush_scheduled_work();
 
@@ -981,6 +1141,8 @@ void mmc_stop_host(struct mmc_host *host
  */
 int mmc_suspend_host(struct mmc_host *host, pm_message_t state)
 {
+	if (host->caps & MMC_CAP_DISABLE)
+		cancel_delayed_work(&host->disable);
 	cancel_delayed_work(&host->detect);
 	mmc_flush_scheduled_work();
 
diff -puN drivers/mmc/core/host.c~mmc-add-enable-and-disable-methods-to-mmc-host drivers/mmc/core/host.c
--- a/drivers/mmc/core/host.c~mmc-add-enable-and-disable-methods-to-mmc-host
+++ a/drivers/mmc/core/host.c
@@ -83,6 +83,7 @@ struct mmc_host *mmc_alloc_host(int extr
 	spin_lock_init(&host->lock);
 	init_waitqueue_head(&host->wq);
 	INIT_DELAYED_WORK(&host->detect, mmc_rescan);
+	INIT_DELAYED_WORK_DEFERRABLE(&host->disable, mmc_host_deeper_disable);
 
 	/*
 	 * By default, hosts do not support SGIO or large requests.
diff -puN drivers/mmc/core/host.h~mmc-add-enable-and-disable-methods-to-mmc-host drivers/mmc/core/host.h
--- a/drivers/mmc/core/host.h~mmc-add-enable-and-disable-methods-to-mmc-host
+++ a/drivers/mmc/core/host.h
@@ -14,5 +14,7 @@
 int mmc_register_host_class(void);
 void mmc_unregister_host_class(void);
 
+void mmc_host_deeper_disable(struct work_struct *work);
+
 #endif
 
diff -puN include/linux/mmc/host.h~mmc-add-enable-and-disable-methods-to-mmc-host include/linux/mmc/host.h
--- a/include/linux/mmc/host.h~mmc-add-enable-and-disable-methods-to-mmc-host
+++ a/include/linux/mmc/host.h
@@ -51,6 +51,35 @@ struct mmc_ios {
 };
 
 struct mmc_host_ops {
+	/*
+	 * Hosts that support power saving can use the 'enable' and 'disable'
+	 * methods to exit and enter power saving states. 'enable' is called
+	 * when the host is claimed and 'disable' is called (or scheduled with
+	 * a delay) when the host is released. The 'disable' is scheduled if
+	 * the disable delay set by 'mmc_set_disable_delay()' is non-zero,
+	 * otherwise 'disable' is called immediately. 'disable' may be
+	 * scheduled repeatedly, to permit ever greater power saving at the
+	 * expense of ever greater latency to re-enable. Rescheduling is
+	 * determined by the return value of the 'disable' method. A positive
+	 * value gives the delay in jiffies.
+	 *
+	 * In the case where a host function (like set_ios) may be called
+	 * with or without the host claimed, enabling and disabling can be
+	 * done directly and will nest correctly. Call 'mmc_host_enable()' and
+	 * 'mmc_host_lazy_disable()' for this purpose, but note that these
+	 * functions must be paired.
+	 *
+	 * Alternatively, 'mmc_host_enable()' may be paired with
+	 * 'mmc_host_disable()' which calls 'disable' immediately.  In this
+	 * case the 'disable' method will be called with 'lazy' set to 0.
+	 * This is mainly useful for error paths.
+	 *
+	 * Because lazy disble may be called from a work queue, the 'disable'
+	 * method must claim the host when 'lazy' != 0, which will work
+	 * correctly because recursion is detected and handled.
+	 */
+	int (*enable)(struct mmc_host *host);
+	int (*disable)(struct mmc_host *host, int lazy);
 	void	(*request)(struct mmc_host *host, struct mmc_request *req);
 	/*
 	 * Avoid calling these three functions too often or in a "fast path",
@@ -118,6 +147,7 @@ struct mmc_host {
 #define MMC_CAP_SPI		(1 << 4)	/* Talks only SPI protocols */
 #define MMC_CAP_NEEDS_POLL	(1 << 5)	/* Needs polling for card-detection */
 #define MMC_CAP_8_BIT_DATA	(1 << 6)	/* Can the host do 8 bit transfers */
+#define MMC_CAP_DISABLE		(1 << 7)	/* Can the host be disabled */
 
 	/* host specific block data */
 	unsigned int		max_seg_size;	/* see blk_queue_max_segment_size */
@@ -142,6 +172,13 @@ struct mmc_host {
 	unsigned int		removed:1;	/* host is being removed */
 #endif
 
+	/* Only used with MMC_CAP_DISABLE */
+	int			enabled;	/* host is enabled */
+	int			nesting_cnt;	/* "enable" nesting count */
+	int			en_dis_recurs;	/* detect recursion */
+	unsigned int		disable_delay;	/* disable delay in msecs */
+	struct delayed_work	disable;	/* disabling work */
+
 	struct mmc_card		*card;		/* device attached to this host */
 
 	wait_queue_head_t	wq;
@@ -197,5 +234,15 @@ struct regulator;
 int mmc_regulator_get_ocrmask(struct regulator *supply);
 int mmc_regulator_set_ocr(struct regulator *supply, unsigned short vdd_bit);
 
+int mmc_host_enable(struct mmc_host *host);
+int mmc_host_disable(struct mmc_host *host);
+int mmc_host_lazy_disable(struct mmc_host *host);
+
+static inline void mmc_set_disable_delay(struct mmc_host *host,
+					 unsigned int disable_delay)
+{
+	host->disable_delay = disable_delay;
+}
+
 #endif
 
_

Patches currently in -mm which might be from adrian.hunter@nokia.com are

mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
mmc-add-enable-and-disable-methods-to-mmc-host.patch
mmc-allow-host-claim-release-nesting.patch
mmc-add-mmc_cap_nonremovable-host-capability.patch
mmc-add-ability-to-save-power-by-powering-off-cards.patch
mmc-add-mmc-card-sleep-and-awake-support.patch
mmc-power-off-once-at-removal.patch
mmc-add-host-capabilities-for-sd-only-and-mmc-only.patch
mmc-check-status-after-mmc-switch-command.patch
omap_hsmmc-add-debugfs-entry-host-registers.patch
omap_hsmmc-make-use-of-new-enable-disable-interface.patch
arm-omap-mmc-twl4030-add-context-loss-counter-support.patch
omap_hsmmc-keep-track-of-power-mode.patch
omap_hsmmc-context-save-restore-support.patch
omap_hsmmc-set-open-drain-bit-correctly.patch
omap_hsmmc-ensure-workqueues-are-empty-before-suspend.patch
omap_hsmmc-fix-scatter-gather-list-sanity-checking.patch
omap_hsmmc-make-use-of-new-mmc_cap_nonremovable-host-capability.patch
omap_hsmmc-support-for-deeper-power-saving-states.patch
arm-omap-mmc-twl4030-add-regulator-sleep-wake-function.patch
omap_hsmmc-put-mmc-regulator-to-sleep.patch
omap_hsmmc-add-mmc-card-sleep-and-awake-support.patch
omap_hsmmc-fix-null-pointer-dereference.patch
omap_hsmmc-cleanup-macro-usage.patch
omap_hsmmc-clear-interrupt-status-after-init-sequence.patch
omap_hsmmc-cater-for-weird-cmd6-behaviour.patch
omap_hsmmc-prevent-races-with-irq-handler.patch
omap_hsmmc-pass-host-capabilities-for-sd-only-and-mmc-only.patch
omap_hsmmc-code-refactoring.patch
omap_hsmmc-protect-the-card-when-the-cover-is-open.patch
omap_hsmmc-ensure-all-clock-enables-and-disables-are-paired.patch
omap_hsmmc-set-a-large-data-timeout-for-commands-with-busy-signal.patch
arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag.patch

