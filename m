Return-Path: <SRS0=JcVV=BI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56AA3C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 29 Jul 2020 23:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3288A2082E
	for <mm-commits@archiver.kernel.org>; Wed, 29 Jul 2020 23:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596066737;
	bh=3ZOFMcKHcASP9u2vm4G+/gxwCfjBWsHYVBbVLFjI3uU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=xXo+blm/uhh29HJLaTTsJn7WCO5kSSc/HHmqmZfFTRevdPPIRV3R69PwpoA5Q8RcU
	 WDjI76rKEV2b7MtBsY+LrhEBJAMjWjL0MCSItCNFTLpnvW47+3DLWD6v701zkj6wZR
	 26gcnWTvXTOECeT4EUNdPbobpIRkCa8nqcrHKDdk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgG2XwQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Jul 2020 19:52:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727115AbgG2XwQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 29 Jul 2020 19:52:16 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1982B207E8;
        Wed, 29 Jul 2020 23:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596066736;
        bh=3ZOFMcKHcASP9u2vm4G+/gxwCfjBWsHYVBbVLFjI3uU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1h1J5W95fLau0UpdaXqfSywIX+2EXHk17OJpq0Zq8/wlU+nk3ICrIxzETRWF5IUKU
         aTEh/YLoTOJla+whpPatFDQ0NYI79IdPQS8FrL/ojRWo+SqaAFxoqSV71gZmYAWrnV
         VZIR1B4YCBXQ2UBLWhm8RhRWTb0MeZ6DOH6EEN1I=
Date:   Wed, 29 Jul 2020 16:52:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, zhaoqianli@xiaomi.com
Subject:  [obsolete]
 mm-slab-avoid-the-use-of-one-element-array-and-use-struct_size-helper.patch
 removed from -mm tree
Message-ID: <20200729235215.H6WuFknWp%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slab: avoid the use of one-element array and use struct_s=
ize() helper
has been removed from the -mm tree.  Its filename was
     mm-slab-avoid-the-use-of-one-element-array-and-use-struct_size-helper.=
patch

This patch was dropped because it is obsolete

------------------------------------------------------
=46rom: Qianli Zhao <zhaoqianli@xiaomi.com>
Subject: mm: slab: avoid the use of one-element array and use struct_size()=
 helper

There is a regular need in the kernel to provide a way to declare having a
dynamically sized set of trailing elements in a structure.  Kernel code
should always use =E2=80=9Cflexible array members=E2=80=9D[1] for these cas=
es.  The
older style of one-element or zero-length arrays should no longer be
used[2].

Make use of the struct_size() helper instead of an open-coded version in
order to avoid any potential type mistakes.

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://github.com/KSPP/linux/issues/21

Link: http://lkml.kernel.org/r/1596034214-15010-1-git-send-email-zhaoqianli=
good@gmail.com
Signed-off-by: Qianli Zhao <zhaoqianli@xiaomi.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h        |    2 +-
 mm/slab_common.c |    7 ++-----
 2 files changed, 3 insertions(+), 6 deletions(-)

--- a/mm/slab_common.c~mm-slab-avoid-the-use-of-one-element-array-and-use-s=
truct_size-helper
+++ a/mm/slab_common.c
@@ -168,9 +168,7 @@ static int init_memcg_params(struct kmem
 	if (!memcg_nr_cache_ids)
 		return 0;
=20
-	arr =3D kvzalloc(sizeof(struct memcg_cache_array) +
-		       memcg_nr_cache_ids * sizeof(void *),
-		       GFP_KERNEL);
+	arr =3D kvzalloc(struct_size(arr, entries, memcg_nr_cache_ids), GFP_KERNE=
L);
 	if (!arr)
 		return -ENOMEM;
=20
@@ -201,8 +199,7 @@ static int update_memcg_params(struct km
 {
 	struct memcg_cache_array *old, *new;
=20
-	new =3D kvzalloc(sizeof(struct memcg_cache_array) +
-		       new_array_size * sizeof(void *), GFP_KERNEL);
+	new =3D kvzalloc(struct_size(new, entries, new_array_size), GFP_KERNEL);
 	if (!new)
 		return -ENOMEM;
=20
--- a/mm/slab.h~mm-slab-avoid-the-use-of-one-element-array-and-use-struct_s=
ize-helper
+++ a/mm/slab.h
@@ -34,7 +34,7 @@ struct kmem_cache {
=20
 struct memcg_cache_array {
 	struct rcu_head rcu;
-	struct kmem_cache *entries[0];
+	struct kmem_cache *entries[];
 };
=20
 /*
_

Patches currently in -mm which might be from zhaoqianli@xiaomi.com are


