Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBB3AC43381
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9587C64F2B
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235126AbhBXUF5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:05:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:55480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235116AbhBXUFP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:05:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57D0764F0C;
        Wed, 24 Feb 2021 20:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197042;
        bh=ChBiOWWFlV55hgQd9As/5MlsMtGmosNljD20kyHR1Xk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nHBNmRJufE8X4VcOw5Ym8jxe0xMIi9KpOvhRa4xmDJcZzlugHBti2tMPRchLF3Pat
         9SscKTlPvoVeU+KecH2Y/Esl3T7VMABxEIigV1mKIT3QTAWtsFie0FYttGJNWQ2++I
         D/+WUTjvJ69+TeIBOUH8DgXAUidc1YiHpQK2iNRk=
Date:   Wed, 24 Feb 2021 12:04:01 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, feng.tang@intel.com, guro@fb.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        torvalds@linux-foundation.org
Subject:  [patch 068/173] mm: page_counter: re-layout structure to
 reduce false sharing
Message-ID: <20210224200401._Hfko2JIY%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Feng Tang <feng.tang@intel.com>
Subject: mm: page_counter: re-layout structure to reduce false sharing

When checking a memory cgroup related performance regression [1], from the
perf c2c profiling data, we found high false sharing for accessing 'usage'
and 'parent'.

On 64 bit system, the 'usage' and 'parent' are close to each other, and
easy to be in one cacheline (for cacheline size =3D=3D 64+ B).  'usage' is
usally written, while 'parent' is usually read as the cgroup's
hierarchical counting nature.

So move the 'parent' to the end of the structure to make sure they
are in different cache lines.

Following are some performance data with the patch, against v5.11-rc1.  [
In the data, A means a platform with 2 sockets 48C/96T, B is a platform of
4 sockests 72C/144T, and if a %stddev will be shown bigger than 2%,
P100/P50 means number of test tasks equals to 100%/50% of nr_cpu]

will-it-scale/malloc1
---------------------
	   v5.11-rc1			v5.11-rc1+patch

A-P100	     15782 =C2=B1  2%      -0.1%      15765 =C2=B1  3%  will-it-scal=
e.per_process_ops
A-P50	     21511            +8.9%      23432        will-it-scale.per_proce=
ss_ops
B-P100	      9155            +2.2%       9357        will-it-scale.per_proc=
ess_ops
B-P50	     10967            +7.1%      11751 =C2=B1  2%  will-it-scale.per_=
process_ops

will-it-scale/pagefault2
------------------------
	   v5.11-rc1			v5.11-rc1+patch

A-P100	     79028            +3.0%      81411        will-it-scale.per_proc=
ess_ops
A-P50	    183960 =C2=B1  2%      +4.4%     192078 =C2=B1  2%  will-it-scale=
.per_process_ops
B-P100	     85966            +9.9%      94467 =C2=B1  3%  will-it-scale.per=
_process_ops
B-P50	    198195            +9.8%     217526        will-it-scale.per_proce=
ss_ops

fio (4k/1M is block size)
-------------------------
	   v5.11-rc1			v5.11-rc1+patch

A-P50-r-4k     16881 =C2=B1  2%    +1.2%      17081 =C2=B1  2%  fio.read_bw=
_MBps
A-P50-w-4k      3931          +4.5%       4111 =C2=B1  2%  fio.write_bw_MBps
A-P50-r-1M     15178          -0.2%      15154        fio.read_bw_MBps
A-P50-w-1M      3924          +0.1%       3929        fio.write_bw_MBps

[1].https://lore.kernel.org/lkml/20201102091543.GM31092@shao2-debian/
Link: https://lkml.kernel.org/r/1611040814-33449-1-git-send-email-feng.tang=
@intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_counter.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/include/linux/page_counter.h~mm-page_counter-relayout-structure-to-re=
duce-false-sharing
+++ a/include/linux/page_counter.h
@@ -12,7 +12,6 @@ struct page_counter {
 	unsigned long low;
 	unsigned long high;
 	unsigned long max;
-	struct page_counter *parent;
=20
 	/* effective memory.min and memory.min usage tracking */
 	unsigned long emin;
@@ -27,6 +26,14 @@ struct page_counter {
 	/* legacy */
 	unsigned long watermark;
 	unsigned long failcnt;
+
+	/*
+	 * 'parent' is placed here to be far from 'usage' to reduce
+	 * cache false sharing, as 'usage' is written mostly while
+	 * parent is frequently read for cgroup's hierarchical
+	 * counting nature.
+	 */
+	struct page_counter *parent;
 };
=20
 #if BITS_PER_LONG =3D=3D 32
_
