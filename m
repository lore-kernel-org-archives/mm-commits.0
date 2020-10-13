Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34B98C43457
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3C5022244
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633369;
	bh=dTFc+WoKqmoJplW4WTmi5+LUUDBBvC7rjNRzWpfDCzs=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=TmnO98GTJ+AB9b/72jxR1YWvnTkt8oljcMUs6kL9uTFAA2VH82RtqIv3MDI/IGO1c
	 FbWRJVQ1c/Ohd281PAquzflUD4InYJqZd5YEmfJX7CytV0X25Ym9ZImiOobMYi1RNM
	 AYtPL5wNawwHkfYhP1Thk6WIvENaY7UZKaHaQ5dc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388601AbgJMX4I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:56:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgJMX4I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:56:08 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C13FC2222E;
        Tue, 13 Oct 2020 23:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633368;
        bh=dTFc+WoKqmoJplW4WTmi5+LUUDBBvC7rjNRzWpfDCzs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=azglKC3oTyCXj248lPjbznTWaPeNulqkZtcHid/XuAWonno2zzwUrkbyXKjq04yY9
         Pcvmf/HBW/28ZiHn7AhD8oMDi2WCdXtsc86PE+4N8OBUgCIWsyif+7ITwlOvcnKSZi
         zsl4iICR5BrHQdgnXOGc6Nt6YfvLSWURvkShScC4=
Date:   Tue, 13 Oct 2020 16:56:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, urezki@gmail.com
Subject:  [patch 140/181] include/linux/gfp.h: clarify usage of
 GFP_ATOMIC in !preemptible contexts
Message-ID: <20201013235607.2toVtY_c5%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Michal Hocko <mhocko@suse.com>
Subject: include/linux/gfp.h: clarify usage of GFP_ATOMIC in !preemptible contexts

There is a general understanding that GFP_ATOMIC/GFP_NOWAIT are to be used
from atomic contexts.  E.g.  from within a spin lock or from the IRQ
context.  This is correct but there are some atomic contexts where the
above doesn't hold.  One of them would be an NMI context.  Page allocator
has never supported that and the general fear of this context didn't let
anybody to actually even try to use the allocator there.  Good, but let's
be more specific about that.

Another such a context, and that is where people seem to be more daring,
is raw_spin_lock.  Mostly because it simply resembles regular spin lock
which is supported by the allocator and there is not any implementation
difference with !RT kernels in the first place.  Be explicit that such a
context is not supported by the allocator.  The underlying reason is that
zone->lock would have to become raw_spin_lock as well and that has turned
out to be a problem for RT
(http://lkml.kernel.org/r/87mu305c1w.fsf@nanos.tec.linutronix.de).

Link: https://lkml.kernel.org/r/20200929123010.5137-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Uladzislau Rezki <urezki@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/gfp.h~mm-clarify-usage-of-gfp_atomic-in-preemptible-contexts
+++ a/include/linux/gfp.h
@@ -238,7 +238,9 @@ struct vm_area_struct;
  * %__GFP_FOO flags as necessary.
  *
  * %GFP_ATOMIC users can not sleep and need the allocation to succeed. A lower
- * watermark is applied to allow access to "atomic reserves"
+ * watermark is applied to allow access to "atomic reserves".
+ * The current implementation doesn't support NMI and few other strict
+ * non-preemptive contexts (e.g. raw_spin_lock). The same applies to %GFP_NOWAIT.
  *
  * %GFP_KERNEL is typical for kernel-internal allocations. The caller requires
  * %ZONE_NORMAL or a lower zone for direct access but can direct reclaim.
_
