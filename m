Return-Path: <SRS0=YRC/=A3=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03286C433FB
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 23:10:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D27E02070E
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 23:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594941021;
	bh=5TSAVIrq+Cq6/e5TkW3EDxQ8WnITSFubK9nPMrlKVkk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=fTbg+cY/4uwHoW6FnobdigoTsM2eHhHXWE33YVBjd2jd+3NKLqVZ2B02RqFl5q+jW
	 vMdQYJpXkhENl6I35k8b1l02ytXkXWA033EuAu/iT0ZqzWAbxFOCeH5juBifwRCVAV
	 aVtjDLNMaUMX5wMcc6jQYh3USBYfzU4UxDBWIHV4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgGPXKV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jul 2020 19:10:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728220AbgGPXKS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Jul 2020 19:10:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88AF220C56;
        Thu, 16 Jul 2020 22:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594939970;
        bh=5TSAVIrq+Cq6/e5TkW3EDxQ8WnITSFubK9nPMrlKVkk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PhOF3P1I8VkE8DDjmgKFbNhkPsNcdGCNM9snxm3v+dIJ6/Y/0BhTIkdVdrmCNMoRg
         7bvrLzakbh8cGh4WdwCqw5qSIzQSSfhwCEI+wsGvqjChTmvu3A9+zCqUVGUJj3mYpn
         FH6x/H7RbCwG6FkjIYB7xcWzEuwxM+f3KDu/AkSo=
Date:   Thu, 16 Jul 2020 15:52:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     mm-commits@vger.kernel.org, raven@themaw.net, rdunlap@infradead.org
Subject:  + autofs-fix-doubled-word.patch added to -mm tree
Message-ID: <20200716225250.vLN47JwlD%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: fix doubled word
has been added to the -mm tree.  Its filename is
     autofs-fix-doubled-word.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-fix-doubled-word.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-fix-doubled-word.patch

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
Subject: autofs: fix doubled word

Change doubled word "is" to "it is".

Link: http://lkml.kernel.org/r/5a82befd-40f8-8dc0-3498-cbc0436cad9b@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/auto_dev-ioctl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/uapi/linux/auto_dev-ioctl.h~autofs-fix-doubled-word
+++ a/include/uapi/linux/auto_dev-ioctl.h
@@ -82,7 +82,7 @@ struct args_ismountpoint {
 /*
  * All the ioctls use this structure.
  * When sending a path size must account for the total length
- * of the chunk of memory otherwise is is the size of the
+ * of the chunk of memory otherwise it is the size of the
  * structure.
  */
 
_

Patches currently in -mm which might be from rdunlap@infradead.org are

linux-sched-mmh-drop-duplicated-words-in-comments.patch
mm-drop-duplicated-words-in-linux-pgtableh.patch
mm-drop-duplicated-words-in-linux-mmh.patch
autofs-fix-doubled-word.patch

