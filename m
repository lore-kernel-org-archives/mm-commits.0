Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A6EC6FA82
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiILE4t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiILE4f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:56:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49F427CED
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:56:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F3AB60C5E
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF3CC433C1;
        Mon, 12 Sep 2022 04:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958584;
        bh=NoWBNyKGD4/eROBIbvu6whCjbqdtzkSGG5GwTKwXPM8=;
        h=Date:To:From:Subject:From;
        b=C5deIMed8SytcaYXUa4evGQySgh+iuUiXEcES1HrJgRNrzR+jUx7LtT3IAe58BBzs
         eNm8tcHqKC/aCog3m4puhWB1dCbAeyYRMc/eknzLiRoL++ju7+dFNCuX3eIovCp2Cd
         3L/m32P8i579mGbNQAF2hXjFJphhMlup1XE+Cub8=
Date:   Sun, 11 Sep 2022 21:56:23 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, pmladek@suse.com,
        linmiaohe@huawei.com, lgoncalv@redhat.com, jlelli@redhat.com,
        ebiederm@xmission.com, bigeasy@linutronix.de, bhe@redhat.com,
        arnd@arndb.de, vschneid@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec-turn-all-kexec_mutex-acquisitions-into-trylocks.patch removed from -mm tree
Message-Id: <20220912045624.AAF3CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kexec: turn all kexec_mutex acquisitions into trylocks
has been removed from the -mm tree.  Its filename was
     kexec-turn-all-kexec_mutex-acquisitions-into-trylocks.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Valentin Schneider <vschneid@redhat.com>
Subject: kexec: turn all kexec_mutex acquisitions into trylocks
Date: Thu, 30 Jun 2022 23:32:57 +0100

Patch series "kexec, panic: Making crash_kexec() NMI safe", v4.


This patch (of 2):

Most acquistions of kexec_mutex are done via mutex_trylock() - those were
a direct "translation" from:

  8c5a1cf0ad3a ("kexec: use a mutex for locking rather than xchg()")

there have however been two additions since then that use mutex_lock():
crash_get_memory_size() and crash_shrink_memory().

A later commit will replace said mutex with an atomic variable, and
locking operations will become atomic_cmpxchg().  Rather than having those
mutex_lock() become while (atomic_cmpxchg(&lock, 0, 1)), turn them into
trylocks that can return -EBUSY on acquisition failure.

This does halve the printable size of the crash kernel, but that's still
neighbouring 2G for 32bit kernels which should be ample enough.

Link: https://lkml.kernel.org/r/20220630223258.4144112-1-vschneid@redhat.com
Link: https://lkml.kernel.org/r/20220630223258.4144112-2-vschneid@redhat.com
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Juri Lelli <jlelli@redhat.com>
Cc: Luis Claudio R. Goncalves <lgoncalv@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |    2 +-
 kernel/kexec_core.c   |   12 ++++++++----
 kernel/ksysfs.c       |    7 ++++++-
 3 files changed, 15 insertions(+), 6 deletions(-)

--- a/include/linux/kexec.h~kexec-turn-all-kexec_mutex-acquisitions-into-trylocks
+++ a/include/linux/kexec.h
@@ -427,7 +427,7 @@ extern int kexec_load_disabled;
 extern bool kexec_in_progress;
 
 int crash_shrink_memory(unsigned long new_size);
-size_t crash_get_memory_size(void);
+ssize_t crash_get_memory_size(void);
 
 #ifndef arch_kexec_protect_crashkres
 /*
--- a/kernel/kexec_core.c~kexec-turn-all-kexec_mutex-acquisitions-into-trylocks
+++ a/kernel/kexec_core.c
@@ -1004,13 +1004,16 @@ void crash_kexec(struct pt_regs *regs)
 	}
 }
 
-size_t crash_get_memory_size(void)
+ssize_t crash_get_memory_size(void)
 {
-	size_t size = 0;
+	ssize_t size = 0;
+
+	if (!mutex_trylock(&kexec_mutex))
+		return -EBUSY;
 
-	mutex_lock(&kexec_mutex);
 	if (crashk_res.end != crashk_res.start)
 		size = resource_size(&crashk_res);
+
 	mutex_unlock(&kexec_mutex);
 	return size;
 }
@@ -1022,7 +1025,8 @@ int crash_shrink_memory(unsigned long ne
 	unsigned long old_size;
 	struct resource *ram_res;
 
-	mutex_lock(&kexec_mutex);
+	if (!mutex_trylock(&kexec_mutex))
+		return -EBUSY;
 
 	if (kexec_crash_image) {
 		ret = -ENOENT;
--- a/kernel/ksysfs.c~kexec-turn-all-kexec_mutex-acquisitions-into-trylocks
+++ a/kernel/ksysfs.c
@@ -105,7 +105,12 @@ KERNEL_ATTR_RO(kexec_crash_loaded);
 static ssize_t kexec_crash_size_show(struct kobject *kobj,
 				       struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%zu\n", crash_get_memory_size());
+	ssize_t size = crash_get_memory_size();
+
+	if (size < 0)
+		return size;
+
+	return sprintf(buf, "%zd\n", size);
 }
 static ssize_t kexec_crash_size_store(struct kobject *kobj,
 				   struct kobj_attribute *attr,
_

Patches currently in -mm which might be from vschneid@redhat.com are


