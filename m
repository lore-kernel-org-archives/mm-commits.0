Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75C90C25B06
	for <mm-commits@archiver.kernel.org>; Mon, 15 Aug 2022 02:01:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiHOCBE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 14 Aug 2022 22:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiHOCBE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 14 Aug 2022 22:01:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61069590
        for <mm-commits@vger.kernel.org>; Sun, 14 Aug 2022 19:01:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B1E7B80C92
        for <mm-commits@vger.kernel.org>; Mon, 15 Aug 2022 02:01:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2736BC433C1;
        Mon, 15 Aug 2022 02:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660528860;
        bh=XDB6S6/ea9m21s/4KN06Dzr/6MpfDa8emBSwuEKmEIw=;
        h=Date:To:From:Subject:From;
        b=1wlzSlBD9p7tAdYCAJJk7XYLCOI2s7Yc5nH99VkG2cxPCbIgGvLtpQflWEjveHqfz
         dSxnWwkKf6yZ1D9p/ZNNb3xxVqoSxRueCRfyjTelZps3f+2NxmlSo/iSOXdah03HHJ
         owQNDGBcLotag1+nV3K6qH6rPEaaXS6ixvZgNn2A=
Date:   Sun, 14 Aug 2022 19:00:58 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, pmladek@suse.com,
        linmiaohe@huawei.com, lgoncalv@redhat.com, jlelli@redhat.com,
        ebiederm@xmission.com, bigeasy@linutronix.de, bhe@redhat.com,
        arnd@arndb.de, vschneid@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-turn-all-kexec_mutex-acquisitions-into-trylocks.patch added to mm-nonmm-unstable branch
Message-Id: <20220815020100.2736BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: turn all kexec_mutex acquisitions into trylocks
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-turn-all-kexec_mutex-acquisitions-into-trylocks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-turn-all-kexec_mutex-acquisitions-into-trylocks.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

kexec-turn-all-kexec_mutex-acquisitions-into-trylocks.patch
panic-kexec-make-__crash_kexec-nmi-safe.patch

