Return-Path: <SRS0=YRC/=A3=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08B4EC4345A
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 23:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D04ED2063A
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 23:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594942936;
	bh=agyFd32ltX8DlhTJx+uM9tFed0apRkw4gdQG8lowyvg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=A1Z9DX6gJ4FkfvK/rGE3yBXvd4RFEoFKCBimfjRFFEMt5uRdPTDhN57DDBY2RmdsJ
	 IyncH5LLsizs1wdQWbBMXsUs/gUEJnfq9sJKdq8lgcnkCzWWrSNhn97BtrcAm5roxi
	 rdUe0TY6qpUG/jyhUK0z1AcrqO2RPZGlrNCV/jz4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgGPXmQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jul 2020 19:42:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbgGPXmQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Jul 2020 19:42:16 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EEBF207DD;
        Thu, 16 Jul 2020 23:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594942935;
        bh=agyFd32ltX8DlhTJx+uM9tFed0apRkw4gdQG8lowyvg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fIdqdpphfv4HptHi3x71bgsNVWnXWSL6U5UFQPVwOhwihzUVYUmoqK4GXWfaHGUd0
         0imf8b0ZEbQIN730oJTMYzAsTEqG+1CqrHevo+rgnb6xI/YiMmQS75DomAf1svSYi8
         3BN+YmBowA+8oTZ2ezFJLeEcNwi0MmL6UQiEslEY=
Date:   Thu, 16 Jul 2020 16:42:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, liao.pingfang@zte.com.cn,
        mm-commits@vger.kernel.org, wang.yi59@zte.com.cn
Subject:  + ipc-shmc-remove-the-superfluous-break.patch added to
 -mm tree
Message-ID: <20200716234215.jtbOlGSm6%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/shm.c: Remove the superfluous break
has been added to the -mm tree.  Its filename is
     ipc-shmc-remove-the-superfluous-break.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-shmc-remove-the-superfluous-break.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-shmc-remove-the-superfluous-break.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Liao Pingfang <liao.pingfang@zte.com.cn>
Subject: ipc/shm.c: Remove the superfluous break

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

ipc-shmc-remove-the-superfluous-break.patch

