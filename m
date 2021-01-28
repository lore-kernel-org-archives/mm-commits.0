Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D39C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 00:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AB0664DD5
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 00:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhA1AT6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Jan 2021 19:19:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:54054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231224AbhA1AT4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Jan 2021 19:19:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4C5764DCC;
        Thu, 28 Jan 2021 00:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611793135;
        bh=j6TmWogfcnEerQqLXEklRWU6ZUKkjCx0d+dStjCCVeo=;
        h=Date:From:To:Subject:From;
        b=MXZkZuyJuCLQu48XS5+7RzdH/VF6wvWv4zXaLKcP0LOElSpVqk1hY9G5NMcaBtqO1
         HMbw4FvtQmcYRLi9b2puFEMX247fIBtsT7l547Bzrzf4LKqi9GwBTFnfkJE+JwE1Mp
         iVvawIrNxxZxskUneTn90rehXmkrFvzcoIPKatnQ=
Date:   Wed, 27 Jan 2021 16:18:54 -0800
From:   akpm@linux-foundation.org
To:     dmitry.torokhov@gmail.com, kwankhede@nvidia.com,
        mm-commits@vger.kernel.org, oleg@redhat.com, rdunlap@infradead.org,
        stefanr@s5r6.in-berlin.de
Subject:  + include-linux-remove-repeated-words.patch added to -mm
 tree
Message-ID: <20210128001854.TSuBB5Kt5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux: remove repeated words
has been added to the -mm tree.  Its filename is
     include-linux-remove-repeated-words.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/include-linux-remove-repeated-words.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/include-linux-remove-repeated-words.patch

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
Subject: include/linux: remove repeated words

Drop the doubled word "for" in a comment. {firewire-cdev.h}
Drop the doubled word "in" in a comment. {input.h}
Drop the doubled word "a" in a comment. {mdev.h}
Drop the doubled word "the" in a comment. {ptrace.h}

Link: https://lkml.kernel.org/r/20210126232444.22861-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Kirti Wankhede <kwankhede@nvidia.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mdev.h               |    2 +-
 include/linux/ptrace.h             |    2 +-
 include/uapi/linux/firewire-cdev.h |    2 +-
 include/uapi/linux/input.h         |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/mdev.h~include-linux-remove-repeated-words
+++ a/include/linux/mdev.h
@@ -42,7 +42,7 @@ struct device *mdev_get_iommu_device(str
  *			@mdev: mdev_device structure on of mediated device
  *			      that is being created
  *			Returns integer: success (0) or error (< 0)
- * @remove:		Called to free resources in parent device's driver for a
+ * @remove:		Called to free resources in parent device's driver for
  *			a mediated device. It is mandatory to provide 'remove'
  *			ops.
  *			@mdev: mdev_device device structure which is being
--- a/include/linux/ptrace.h~include-linux-remove-repeated-words
+++ a/include/linux/ptrace.h
@@ -171,7 +171,7 @@ static inline void ptrace_event(int even
  *
  * Check whether @event is enabled and, if so, report @event and @pid
  * to the ptrace parent.  @pid is reported as the pid_t seen from the
- * the ptrace parent's pid namespace.
+ * ptrace parent's pid namespace.
  *
  * Called without locks.
  */
--- a/include/uapi/linux/firewire-cdev.h~include-linux-remove-repeated-words
+++ a/include/uapi/linux/firewire-cdev.h
@@ -844,7 +844,7 @@ struct fw_cdev_queue_iso {
  * struct fw_cdev_start_iso - Start an isochronous transmission or reception
  * @cycle:	Cycle in which to start I/O.  If @cycle is greater than or
  *		equal to 0, the I/O will start on that cycle.
- * @sync:	Determines the value to wait for for receive packets that have
+ * @sync:	Determines the value to wait for receive packets that have
  *		the %FW_CDEV_ISO_SYNC bit set
  * @tags:	Tag filter bit mask.  Only valid for isochronous reception.
  *		Determines the tag values for which packets will be accepted.
--- a/include/uapi/linux/input.h~include-linux-remove-repeated-words
+++ a/include/uapi/linux/input.h
@@ -84,7 +84,7 @@ struct input_id {
  * in units per radian.
  * When INPUT_PROP_ACCELEROMETER is set the resolution changes.
  * The main axes (ABS_X, ABS_Y, ABS_Z) are then reported in
- * in units per g (units/g) and in units per degree per second
+ * units per g (units/g) and in units per degree per second
  * (units/deg/s) for rotational axes (ABS_RX, ABS_RY, ABS_RZ).
  */
 struct input_absinfo {
_

Patches currently in -mm which might be from rdunlap@infradead.org are

hexagon-remove-config_experimental-from-defconfigs.patch
ntfs-layouth-delete-duplicated-words.patch
fs-delete-repeated-words-in-comments.patch
mm-zswap-clean-up-confusing-comment.patch
alpha-remove-config_experimental-from-defconfigs.patch
include-linux-remove-repeated-words.patch
kernel-delete-repeated-words-in-comments.patch

