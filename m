Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93E91C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70A5620658
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196230;
	bh=YzWEZFtlidsjG5CeIpx0KVpBniFI8HOzjKKOZnxctwM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=dYTvomzXOzWnnzxJefb0L1JIU6bii/0vrLIN64fsVf0YpUqVfI1mPkGIcJtEe7ooe
	 3JmmfRJ+ycKiLAVYnvQr8e6CxkWh6+NgH2A6N+obdRNo8ofdMSf7Q/aLB9qQbZ71xC
	 NHili2zyoQRdkFtftbORjb3jsVuCiaddIzf9QudA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgHLBhK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:37:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBhK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:37:10 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88E3A2054F;
        Wed, 12 Aug 2020 01:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196228;
        bh=YzWEZFtlidsjG5CeIpx0KVpBniFI8HOzjKKOZnxctwM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=P9YYgqcXyGiqDeO//x4if4Vxjn1/Rb2c3LyROq8HyJzUmtlZnHt0u99enRQZnjvGI
         ERwBmidTOQV9y0/MbxfT1ht6JL9jUxVKdnXhGW79drUIbSpSLrDYdJ8NCZ6D7Rsz00
         kvBEiaz2D2Y20Br9zKIlJpRz485puPg2Mhm6cNjU=
Date:   Tue, 11 Aug 2020 18:37:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, liao.pingfang@zte.com.cn,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, wang.yi59@zte.com.cn
Subject:  [patch 130/165] ipc/shm.c: remove the superfluous break
Message-ID: <20200812013708.QzztAezN9%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
