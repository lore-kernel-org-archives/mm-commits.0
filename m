Return-Path: <SRS0=JcVV=BI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 840EDC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 29 Jul 2020 21:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C28520838
	for <mm-commits@archiver.kernel.org>; Wed, 29 Jul 2020 21:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596059394;
	bh=86L98aBIueN22v85snIfw6A6bnjZQKy/lKHFSxUfWNw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=WXNv1OZqWGmvcXrNIqiMNNX3hDN4kZGjhwT+HYel7o88h0dtJ0MKcdPZY8BhsLT7n
	 31vlcmbFi90nJapC8OZZPWTwy+iF9UnBFnONElUNRjmu1VLLEeRB9TcwNjK9QpL4Vd
	 K3FxSkLc1Wl0h7t/tGRc1D2jyPnaoszQnbwJKk4c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgG2Vty (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Jul 2020 17:49:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbgG2Vtx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 29 Jul 2020 17:49:53 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D654E20809;
        Wed, 29 Jul 2020 21:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596059393;
        bh=86L98aBIueN22v85snIfw6A6bnjZQKy/lKHFSxUfWNw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=tjk4yVWOmiGclqGRWucTYFXAkMBURkKwihLaFitLi7hYxxIDfcojc8wHuFS9B56cf
         3FBK8G7QBpAbl/ttDMu5XfVitF07Ev2PCbmEQzTMu1mfCcA48gITxaQZxBZCK/0U+G
         84QAX8ZWTljART6duId78jErCL4Y8R7LzVoHVteY=
Date:   Wed, 29 Jul 2020 14:49:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, zhaoqianli@xiaomi.com
Subject:  +
 mm-slab-avoid-the-use-of-one-element-array-and-use-struct_size-helper.patch
 added to -mm tree
Message-ID: <20200729214952.PnzePiWMx%akpm@linux-foundation.org>
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
has been added to the -mm tree.  Its filename is
     mm-slab-avoid-the-use-of-one-element-array-and-use-struct_size-helper.=
patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-avoid-the-use-of-one-e=
lement-array-and-use-struct_size-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-avoid-the-use-of-one-e=
lement-array-and-use-struct_size-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-slab-avoid-the-use-of-one-element-array-and-use-struct_size-helper.patch

