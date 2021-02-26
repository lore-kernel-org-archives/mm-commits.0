Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D71FC4332D
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02D1B64F35
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhBZBWh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:22:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:52600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229841AbhBZBVd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:21:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6298D64F32;
        Fri, 26 Feb 2021 01:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302458;
        bh=UJemYaBn5Wx0GUN4JbzIDHdLk7ZPE1DprunTRJy9aZM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=QiNksz+ZV2OQA1btrmC3OV+NqmA9cby8jsQ2uzbO9mOXFqwwyKLWPIk+mamhEZxlw
         3liY5YdCY2zPxVIbGg+0tKbyrS4C3qi06AfvxHNQVnb2yvr8QFg7K+PhJAqUpDXQEn
         eWoXpM/ec9paE450Nv9hck71lko10uy/OiVaa8Y0=
Date:   Thu, 25 Feb 2021 17:20:56 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dmitry.torokhov@gmail.com,
        kwankhede@nvidia.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, oleg@redhat.com, rdunlap@infradead.org,
        stefanr@s5r6.in-berlin.de, torvalds@linux-foundation.org
Subject:  [patch 086/118] include/linux: remove repeated words
Message-ID: <20210226012056.J-KfMvxAI%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
