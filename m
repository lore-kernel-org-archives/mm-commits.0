Return-Path: <SRS0=29NR=AV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55A4FC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 21:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 219C92075D
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 21:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594415796;
	bh=qP9A3YnJw8xWgr84fxavD+TwL+yT2bxKebDAmzxiQ24=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Xt1hihmFBpQ3JGU4mHnb+/sJ72UBd5wylBRQ6lSdxBaf8jM7z4jHHPvBslCxRv06M
	 J1LA324lRddRBG8znCLNoIDAm6Ac+bA80WC7VH8YbPi/8dExALVxqauOxwj0BFFIQd
	 tFj4BnpHmq8DBKQAG03C8yQriJHAgG85sKBAQxt8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgGJVQf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Jul 2020 17:16:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726223AbgGJVQe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Jul 2020 17:16:34 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC1452075D;
        Fri, 10 Jul 2020 21:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594415793;
        bh=qP9A3YnJw8xWgr84fxavD+TwL+yT2bxKebDAmzxiQ24=;
        h=Date:From:To:Subject:From;
        b=pXujeyz29hvnmCr0WcyTXPuG0RfJPAVQPTKqZJlTvlhSO152aHckU/3tJR4zWqMc6
         jdid/s5EyiXs47FlybTKlGW+diYLAZh5kJlz2ya363k+Ev9TbqREX/mIU6eRwCRiUf
         xSGRHL/JLTWFMCEyWOgsYcb3TleDiwfIvRlTR6Kc=
Date:   Fri, 10 Jul 2020 14:16:33 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, dave@stgolabs.net, manfred@colorfullife.com,
        mm-commits@vger.kernel.org
Subject:  + ipc-uninline-functions.patch added to -mm tree
Message-ID: <20200710211633.AXw5e_xzz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: uninline functions
has been added to the -mm tree.  Its filename is
     ipc-uninline-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-uninline-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-uninline-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: ipc: uninline functions

Two functions are only called via function pointers, don't bother
inlining them.

Link: http://lkml.kernel.org/r/20200710200312.GA960353@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    3 +--
 ipc/shm.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/ipc/sem.c~ipc-uninline-functions
+++ a/ipc/sem.c
@@ -585,8 +585,7 @@ static int newary(struct ipc_namespace *
 /*
  * Called with sem_ids.rwsem and ipcp locked.
  */
-static inline int sem_more_checks(struct kern_ipc_perm *ipcp,
-				struct ipc_params *params)
+static int sem_more_checks(struct kern_ipc_perm *ipcp, struct ipc_params *params)
 {
 	struct sem_array *sma;
 
--- a/ipc/shm.c~ipc-uninline-functions
+++ a/ipc/shm.c
@@ -711,8 +711,7 @@ no_file:
 /*
  * Called with shm_ids.rwsem and ipcp locked.
  */
-static inline int shm_more_checks(struct kern_ipc_perm *ipcp,
-				struct ipc_params *params)
+static int shm_more_checks(struct kern_ipc_perm *ipcp, struct ipc_params *params)
 {
 	struct shmid_kernel *shp;
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

ramfs-support-o_tmpfile.patch
ipc-uninline-functions.patch

