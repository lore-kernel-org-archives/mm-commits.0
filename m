From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-slub-dont-wait-for-high-order-page-allocation-v2.patch removed from -mm
 tree
Date: Fri, 07 Aug 2015 15:21:44 -0700
Message-ID: <55c52f78.kTfl5HdHQZGYecg3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46879 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946342AbbHGWVq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2015 18:21:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: don't wait for high-order page allocation
has been removed from the -mm tree.  Its filename was
     mm-slub-dont-wait-for-high-order-page-allocation-v2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Return-Path: <js1304@gmail.com>
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on z
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=2.0 tests=BAYES_00,
	FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,T_DKIM_INVALID autolearn=no
	version=3.3.1
Received: from localhost (localhost [127.0.0.1])
	by localhost.localdomain (8.14.3/8.14.3) with ESMTP id t772A6JB025626
	for <akpm@localhost>; Thu, 6 Aug 2015 19:10:06 -0700
X-Original-To: akpm@mail.linuxfoundation.org
Delivered-To: akpm@mail.linuxfoundation.org
Received: from mail.linuxfoundation.org [140.211.169.12]
	by localhost with IMAP (fetchmail-6.3.11)
	for <akpm@localhost> (single-drop); Thu, 06 Aug 2015 19:10:06 -0700 (PDT)
Received: from smtp1.linuxfoundation.org (smtp1.linux-foundation.org [172.17.192.35])
	by mail.linuxfoundation.org (Postfix) with ESMTPS id E307C4D3
	for <akpm@mail.linuxfoundation.org>; Fri,  7 Aug 2015 02:10:20 +0000 (UTC)
X-Greylist: whitelisted by SQLgrey-1.7.6
Received: from mail-pa0-f42.google.com (mail-pa0-f42.google.com [209.85.220.42])
	by smtp1.linuxfoundation.org (Postfix) with ESMTPS id A1028E8
	for <akpm@mail.linuxfoundation.org>; Fri,  7 Aug 2015 02:10:20 +0000 (UTC)
Received: by pabyb7 with SMTP id yb7so43823311pab.0
        for <akpm@mail.linuxfoundation.org>; Thu, 06 Aug 2015 19:10:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20130820;
        h=x-gm-message-state:dkim-signature:from:to:cc:subject:date
         :message-id:delivered-to;
        bh=Z4ueXtVzlX3drwfV8szzvcgu7BcMkM40S7Y/rJ/pExg=;
        b=a1S1YlW0N5lMp+0EcFS1MO7qiRMFsQEXyaUIswaKIJxadUaXFMtoCMhyVqABhIj+qm
         kyInNE+Mhtrd5NhpKjMIKYakNOjF1585r9heF6tfM+ESMT1geft6jyjWAprWMQbecvfx
         oF1ZojXhC1JDA/ElzPv91G+YouUlc8Iq8fAV9Qb92ZmlY4fG45ILLMzsTpK2hqpZGsr7
         2TynEtPHVYXvQrQa6ueErzr2jnMGFftqpdxjy4yQuOEha5lr8H/2Ikm4/B9fUqRHwtj2
         h2EwndRzmjZDusuipItc9JX6VawsClPcdTQbz0Ka2UHYPJcBVvDPjcYxM5LQYNkYvLks
         +P8w==
X-Received: by 10.66.119.70 with SMTP id ks6mr9301749pab.113.1438913420463;
        Thu, 06 Aug 2015 19:10:20 -0700 (PDT)
X-Gm-Message-State: ALoCoQn6RVUQ+trQweZYyF5vOsg3SZZu3AHn5Ypu2WPBuv0p+Qh/TrXkGHzdT4F7RD8JzjjdPsfgbZ50MiOmhg3rIgztkJhCnXMSZbMK2kJWM6c3a23PvhMjFDQ6pY8HVDkg0bVoohu6MspqYAmWNYh7ybapRFo6j5SpVbtUMblxrjdNoR7auA6Uvwpvmti42kLCrOB55qTC
X-Received: by 10.66.119.70 with SMTP id ks6mr9301668pab.113.1438913419802;
        Thu, 06 Aug 2015 19:10:19 -0700 (PDT)
Received: from mail-pa0-x233.google.com (mail-pa0-x233.google.com. [2607:f8b0:400e:c03::233])
        by mx.google.com with ESMTPS id h8si14831588pdn.89.2015.08.06.19.10.19
        for <akpm@linux-foundation.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Aug 2015 19:10:19 -0700 (PDT)
Received-SPF: pass (google.com: domain of js1304@gmail.com designates 2607:f8b0:400e:c03::233 as permitted sender) client-ip=2607:f8b0:400e:c03::233;
Authentication-Results: mx.google.com;
       spf=pass (google.com: domain of js1304@gmail.com designates 2607:f8b0:400e:c03::233 as permitted sender) smtp.mail=js1304@gmail.com;
       dkim=pass header.i=@gmail.com;
       dmarc=pass (p=NONE dis=NONE) header.from=gmail.com
Received: by pacrr5 with SMTP id rr5so40655860pac.3
        for <akpm@linux-foundation.org>; Thu, 06 Aug 2015 19:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=Z4ueXtVzlX3drwfV8szzvcgu7BcMkM40S7Y/rJ/pExg=;
        b=INJDUA9WEOr3ggFvU53HmSeXgVbfV6LBiUO7oiiQ6GDUXBnwWdCOLMzfTpf8AH0bhP
         ir++pMGjZjxUHiamcroyhgNb24CQ5xfJRzrwdF6aLjVi/8qASw3wryVaar57GDScNRtI
         XjoA3cieuPqRcL61yZoPKYT+5YUMOlz++FVkkx34NH6xJ/aPHTZFIyllSHoW5WLzDz5L
         nAHmHcumRn1uX4XyPcaviRRgdNde1gvU9zzd0mcqz2ag+B69kNMsbpTHM2TQRbjUWwrI
         4xqMgG4+KrFtnWjxnSRZgHSDr5K5ppplALVulu3Orub526mFsDeeW7j9Qk+pppXhey1q
         6pZQ==
X-Received: by 10.68.177.4 with SMTP id cm4mr9430942pbc.76.1438913419319;
        Thu, 06 Aug 2015 19:10:19 -0700 (PDT)
Received: from localhost.localdomain ([119.69.155.222])
        by smtp.gmail.com with ESMTPSA id ea4sm7992610pbc.48.2015.08.06.19.10.13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 06 Aug 2015 19:10:18 -0700 (PDT)
From: Joonsoo Kim <js1304@gmail.com>
X-Google-Original-From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Shaohua Li <shli@fb.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Eric Dumazet <edumazet@google.com>
Subject: mm/slub: don't wait for high-order page allocation
Date: Fri,  7 Aug 2015 11:10:03 +0900
Message-Id: <1438913403-3682-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.9.1
Delivered-To: akpm@linux-foundation.org

Almost description is copied from commit fb05e7a89f50
("net: don't wait for order-3 page allocation").

I saw excessive direct memory reclaim/compaction triggered by slub.
This causes performance issues and add latency. Slub uses high-order
allocation to reduce internal fragmentation and management overhead. But,
direct memory reclaim/compaction has high overhead and the benefit of
high-order allocation can't compensate the overhead of both work.

This patch makes auxiliary high-order allocation atomic. If there is
no memory pressure and memory isn't fragmented, the alloction will still
success, so we don't sacrifice high-order allocation's benefit here.
If the atomic allocation fails, direct memory reclaim/compaction will not
be triggered, allocation fallback to low-order immediately, hence
the direct memory reclaim/compaction overhead is avoided. In the
allocation failure case, kswapd is waken up and trying to make high-order
freepages, so allocation could success next time.

Following is the test to measure effect of this patch.

System: QEMU, CPU 8, 512 MB
Mem: 25% memory is allocated at random position to make fragmentation.
 Memory-hogger occupies 150 MB memory.
Workload: hackbench -g 20 -l 1000

Average result by 10 runs (Base va Patched)

elapsed_time(s): 4.3468 vs 2.9838
compact_stall: 461.7 vs 73.6
pgmigrate_success: 28315.9 vs 7256.1

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/slub.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 257283f..52b9025 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1364,6 +1364,8 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	 * so we fall-back to the minimum order allocation.
 	 */
 	alloc_gfp = (flags | __GFP_NOWARN | __GFP_NORETRY) & ~__GFP_NOFAIL;
+	if ((alloc_gfp & __GFP_WAIT) && oo_order(oo) > oo_order(s->min))
+		alloc_gfp = (alloc_gfp | __GFP_NOMEMALLOC) & ~__GFP_WAIT;
 
 	page = alloc_slab_page(s, alloc_gfp, node, oo);
 	if (unlikely(!page)) {
-- 
1.9.1

Patches currently in -mm which might be from js1304@gmail.com are

mm-slub-dont-wait-for-high-order-page-allocation.patch

