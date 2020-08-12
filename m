Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9A4EC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7903D207F7
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266353;
	bh=LkeCr8OMHppb5Q9hbMryB/c6xkob4HwW22rYznTrmf0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=vH8aIDxUL6K7f3cxcEzM10Xe4cbPGpZ4ctNP4T77gymnSfmsuQHr7sx5vIEiqbQv8
	 74JS2A5RKhFo9V0lZ5fkLOBsFUASxK82dq6Yl+y6eCdwz/DE/VRvN/eTrCAL4z2v7U
	 14Irf2ifXHWP6THuaoMNzkHKta2Vl+TdeB8KPyJA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgHLVFx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgHLVFw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:05:52 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 803312080C;
        Wed, 12 Aug 2020 21:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266350;
        bh=LkeCr8OMHppb5Q9hbMryB/c6xkob4HwW22rYznTrmf0=;
        h=Date:From:To:Subject:From;
        b=h41RJ5uArqqylruRNHhTdHVjxBAYxzUkA0883XDr6+ni9zI2b3tZHYu8kX6726sxr
         MdUguW/Q6pUGqCbZoV+xoM35c+UJaEPWMWHHufOfhCJq+ju1ajcx0+rcWQkzQZbE85
         g/GelFmai3z6ywXTv9Yv0IO6sIg5yyTW4kfu/lSY=
Date:   Wed, 12 Aug 2020 14:05:50 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, liao.pingfang@zte.com.cn,
        mm-commits@vger.kernel.org, wang.yi59@zte.com.cn
Subject:  [merged] ipc-shmc-remove-the-superfluous-break.patch
 removed from -mm tree
Message-ID: <20200812210550.EIVVtO2IU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/shm.c: remove the superfluous break
has been removed from the -mm tree.  Its filename was
     ipc-shmc-remove-the-superfluous-break.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liao Pingfang <liao.pingfang@zte.com.cn>
Subject: ipc/shm.c: remove the superfluous break

Remove the superfuous break, as there is a 'return' before it.

Link: http://lkml.kernel.org/r/1594724361-11525-1-git-send-email-wang.yi59@zte.com.cn
Signed-off-by: Liao Pingfang <liao.pingfang@zte.com.cn>
Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    1 -
 1 file changed, 1 deletion(-)

--- a/ipc/shm.c~ipc-shmc-remove-the-superfluous-break
+++ a/ipc/shm.c
@@ -1380,7 +1380,6 @@ static long compat_ksys_shmctl(int shmid
 	case SHM_LOCK:
 	case SHM_UNLOCK:
 		return shmctl_do_lock(ns, shmid, cmd);
-		break;
 	default:
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from liao.pingfang@zte.com.cn are


