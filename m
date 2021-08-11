Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D58C4338F
	for <mm-commits@archiver.kernel.org>; Wed, 11 Aug 2021 04:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A36C860E78
	for <mm-commits@archiver.kernel.org>; Wed, 11 Aug 2021 04:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhHKEam (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Aug 2021 00:30:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229534AbhHKEal (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 11 Aug 2021 00:30:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B125960F35;
        Wed, 11 Aug 2021 04:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628656218;
        bh=qGaEw9TwQmsiICGy12YDYnORu7yp4ojlWkmbgAQ7YHU=;
        h=Date:From:To:Subject:From;
        b=eKmJQ716P/k9AmNZr30A3LoNbGOZcadZfOVAstksOOdH6ecci4zrVO+n8fFs4IZNN
         JUOpOgKthCd7Cprn+xtXJ4QjLb+Y9igHdjANSQS92ES8TAjtnwhPxk8m2AuTWmCBNr
         HHywAW14X8YNJU34XKeX/cGXN3fv+9ApLJmYeJ6Q=
Date:   Tue, 10 Aug 2021 21:30:16 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vincent.donnefort@arm.com,
        valentin.schneider@arm.com, tglx@linutronix.de,
        peterz@infradead.org, mingo@kernel.org, rdunlap@infradead.org
Subject:  + kernel-cpuc-eliminate-all-kernel-doc-warnings.patch added
 to -mm tree
Message-ID: <20210811043016.-ahQ6%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/cpu.c: eliminate all kernel-doc warnings
has been added to the -mm tree.  Its filename is
     kernel-cpuc-eliminate-all-kernel-doc-warnings.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-cpuc-eliminate-all-kernel-doc-warnings.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-cpuc-eliminate-all-kernel-doc-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: kernel/cpu.c: eliminate all kernel-doc warnings

kernel/cpu.c:57: warning: cannot understand function prototype: 'struct cpuhp_cpu_state '
kernel/cpu.c:115: warning: cannot understand function prototype: 'struct cpuhp_step '
kernel/cpu.c:146: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * cpuhp_invoke_callback _ Invoke the callbacks for a given state
kernel/cpu.c:1998: warning: Function parameter or member 'name' not described in '__cpuhp_setup_state_cpuslocked'
kernel/cpu.c:75: warning: Function parameter or member 'fail' not described in 'cpuhp_cpu_state'
kernel/cpu.c:75: warning: Function parameter or member 'cpu' not described in 'cpuhp_cpu_state'
kernel/cpu.c:75: warning: Function parameter or member 'node' not described in 'cpuhp_cpu_state'
kernel/cpu.c:75: warning: Function parameter or member 'last' not described in 'cpuhp_cpu_state'
kernel/cpu.c:130: warning: Function parameter or member 'list' not described in 'cpuhp_step'
kernel/cpu.c:130: warning: Function parameter or member 'multi_instance' not described in 'cpuhp_step'
kernel/cpu.c:158: warning: No description found for return value of 'cpuhp_invoke_callback'
kernel/cpu.c:1188: warning: No description found for return value of 'cpu_device_down'
kernel/cpu.c:1400: warning: No description found for return value of 'cpu_device_up'
kernel/cpu.c:1425: warning: No description found for return value of 'bringup_hibernate_cpu'

Link: https://lkml.kernel.org/r/20210809223825.24512-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Valentin Schneider <valentin.schneider@arm.com>
Cc: Vincent Donnefort <vincent.donnefort@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

--- a/kernel/cpu.c~kernel-cpuc-eliminate-all-kernel-doc-warnings
+++ a/kernel/cpu.c
@@ -41,14 +41,19 @@
 #include "smpboot.h"
 
 /**
- * cpuhp_cpu_state - Per cpu hotplug state storage
+ * struct cpuhp_cpu_state - Per cpu hotplug state storage
  * @state:	The current cpu state
  * @target:	The target state
+ * @fail:	Current CPU hotplug callback state
  * @thread:	Pointer to the hotplug thread
  * @should_run:	Thread should execute
  * @rollback:	Perform a rollback
  * @single:	Single callback invocation
  * @bringup:	Single callback bringup or teardown selector
+ * @cpu:	CPU number
+ * @node:	Remote CPU node; for multi-instance, do a
+ *		single entry callback for install/remove
+ * @last:	For multi-instance rollback, remember how far we got
  * @cb_state:	The state for a single callback (install/uninstall)
  * @result:	Result of the operation
  * @done_up:	Signal completion to the issuer of the task for cpu-up
@@ -106,11 +111,12 @@ static inline void cpuhp_lock_release(bo
 #endif
 
 /**
- * cpuhp_step - Hotplug state machine step
+ * struct cpuhp_step - Hotplug state machine step
  * @name:	Name of the step
  * @startup:	Startup function of the step
  * @teardown:	Teardown function of the step
  * @cant_stop:	Bringup/teardown can't be stopped at this step
+ * @multi_instance:	State has multiple instances which get added afterwards
  */
 struct cpuhp_step {
 	const char		*name;
@@ -124,7 +130,9 @@ struct cpuhp_step {
 		int		(*multi)(unsigned int cpu,
 					 struct hlist_node *node);
 	} teardown;
+	/* private: */
 	struct hlist_head	list;
+	/* public: */
 	bool			cant_stop;
 	bool			multi_instance;
 };
@@ -143,7 +151,7 @@ static bool cpuhp_step_empty(bool bringu
 }
 
 /**
- * cpuhp_invoke_callback _ Invoke the callbacks for a given state
+ * cpuhp_invoke_callback - Invoke the callbacks for a given state
  * @cpu:	The cpu for which the callback should be invoked
  * @state:	The state to do callbacks for
  * @bringup:	True if the bringup callback should be invoked
@@ -151,6 +159,8 @@ static bool cpuhp_step_empty(bool bringu
  * @lastp:	For multi-instance rollback, remember how far we got
  *
  * Called from cpu hotplug and from the state register machinery.
+ *
+ * Return: %0 on success or a negative errno code
  */
 static int cpuhp_invoke_callback(unsigned int cpu, enum cpuhp_state state,
 				 bool bringup, struct hlist_node *node,
@@ -1183,6 +1193,8 @@ static int cpu_down(unsigned int cpu, en
  * This function is meant to be used by device core cpu subsystem only.
  *
  * Other subsystems should use remove_cpu() instead.
+ *
+ * Return: %0 on success or a negative errno code
  */
 int cpu_device_down(struct device *dev)
 {
@@ -1395,6 +1407,8 @@ out:
  * This function is meant to be used by device core cpu subsystem only.
  *
  * Other subsystems should use add_cpu() instead.
+ *
+ * Return: %0 on success or a negative errno code
  */
 int cpu_device_up(struct device *dev)
 {
@@ -1420,6 +1434,8 @@ EXPORT_SYMBOL_GPL(add_cpu);
  * On some architectures like arm64, we can hibernate on any CPU, but on
  * wake up the CPU we hibernated on might be offline as a side effect of
  * using maxcpus= for example.
+ *
+ * Return: %0 on success or a negative errno code
  */
 int bringup_hibernate_cpu(unsigned int sleep_cpu)
 {
@@ -1976,6 +1992,7 @@ EXPORT_SYMBOL_GPL(__cpuhp_state_add_inst
 /**
  * __cpuhp_setup_state_cpuslocked - Setup the callbacks for an hotplug machine state
  * @state:		The state to setup
+ * @name:		Name of the step
  * @invoke:		If true, the startup function is invoked for cpus where
  *			cpu state >= @state
  * @startup:		startup callback function
@@ -1984,9 +2001,9 @@ EXPORT_SYMBOL_GPL(__cpuhp_state_add_inst
  *			added afterwards.
  *
  * The caller needs to hold cpus read locked while calling this function.
- * Returns:
+ * Return:
  *   On success:
- *      Positive state number if @state is CPUHP_AP_ONLINE_DYN
+ *      Positive state number if @state is CPUHP_AP_ONLINE_DYN;
  *      0 for all other states
  *   On failure: proper (negative) error code
  */
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-migrate-correct-kernel-doc-notation.patch
alpha-agp-make-empty-macros-use-do-while-0-style.patch
alpha-pci-sysfs-fix-all-kernel-doc-warnings.patch
kernel-cpuc-eliminate-all-kernel-doc-warnings.patch
lib-dump_stack-correct-kernel-doc-notation.patch
lib-iov_iterc-fix-kernel-doc-warnings.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix.patch
mm-workingset-correct-kernel-doc-notations.patch
scripts-check_extable-fix-typo-in-user-error-message.patch

