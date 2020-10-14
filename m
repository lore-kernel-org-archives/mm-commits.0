Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90A5EC433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 450E8221FF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709387;
	bh=5UPXZG47x4X9L6mOLhUHtDLCeQS9nBjgR86QANV4xuY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=KyMGEYAGINnm8q966iGrxhTO8/f69FThB4wLmbucu7v2BPhTthhgtJSLfse+LimlS
	 /tLf3Fgh6ZHLnoFreM9nh87uUaA2rQ2f0/67OXpOVn7vt2x+xaWFRuAzw/wvzwmzkV
	 tXejP10dbaFxTYu6cq3XIb5Vj/IGRypGg9qvxuPo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387867AbgJNVDG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:03:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387703AbgJNVDG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:03:06 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85C76214D8;
        Wed, 14 Oct 2020 21:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709384;
        bh=5UPXZG47x4X9L6mOLhUHtDLCeQS9nBjgR86QANV4xuY=;
        h=Date:From:To:Subject:From;
        b=VXnMX6+WT02Vdoa8fku5E4mgmAShpX5aQE0ERQs+ZTzMs7JM/zMLd0KzeYSbKbkHO
         IPIdmBNyU+1OKWpS/L2h47O0z3E3anX4OMijIbUf4vZOrE1eZuodPwPgTMqlegklxL
         PYa8wJfbzmpkGYzpI4S0E7kDzS0DkSelOTRNBCNQ=
Date:   Wed, 14 Oct 2020 14:03:04 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, urezki@gmail.com
Subject:  [merged]
 mm-clarify-usage-of-gfp_atomic-in-preemptible-contexts.patch removed from
 -mm tree
Message-ID: <20201014210304.r2Z3RrgtP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/gfp.h: clarify usage of GFP_ATOMIC in !preemptible contexts
has been removed from the -mm tree.  Its filename was
     mm-clarify-usage-of-gfp_atomic-in-preemptible-contexts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from mhocko@suse.com are


