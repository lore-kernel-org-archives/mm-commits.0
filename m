Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CE64C2BBCA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:09:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4604223407
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgLPRJo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:09:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:60034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727019AbgLPRJn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:09:43 -0500
Date:   Wed, 16 Dec 2020 09:08:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138527;
        bh=s28Z4hiVKmZhM1uQSllWZWuSOtgABAUHJTKT7JBmhxg=;
        h=From:To:Subject:From;
        b=s6dWlG83yp/vzaAAmEEC7w/ZWKpIs6QoGJFyj5fjTBZ1Y9vAEhUUGyuRoIM6vX7ii
         tr3NWe7xPvycA8ct9xHTQmE8vgjgL/+eRRXI89HB0NX33miQgxSWxDEytuX5QjLmar
         0khXhDNBrdnn9K7etdlTWEoLejrTDL9HiYZWWMfQ=
From:   akpm@linux-foundation.org
To:     gustavoars@kernel.org, mm-commits@vger.kernel.org
Subject:  [merged]
 lib-stackdepotc-replace-one-element-array-with-flexible-array-member.patch
 removed from -mm tree
Message-ID: <20201216170847.-AMuGHe5W%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot.c: replace one-element array with flexible-arr=
ay member
has been removed from the -mm tree.  Its filename was
     lib-stackdepotc-replace-one-element-array-with-flexible-array-member.p=
atch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: lib/stackdepot.c: replace one-element array with flexible-array me=
mber

Patch series "] lib/stackdepot.c: Replace one-element array with flexible-a=
rray member".

This series aims to replace a one-element array with a flexible-array
member.  Also, make use of the struct_size(), flexible_array_size() and
array_size() helpers.


This patch (of 3):

There is a regular need in the kernel to provide a way to declare having a
dynamically sized set of trailing elements in a structure.  Kernel code
should always use =E2=80=9Cflexible array members=E2=80=9D[1] for these cas=
es.  The
older style of one-element or zero-length arrays should no longer be
used[2].

Refactor the code according to the use of a flexible-array member in
struct stack_record, instead of a one-element array, and use the
struct_size() helper to calculate the size for the allocation.

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.9-rc1/process/deprecated.html#zero-l=
ength-and-one-element-arrays

Link: https://lkml.kernel.org/r/cover.1601565471.git.gustavoars@kernel.org
Link: https://lore.kernel.org/lkml/5f75876b.x9zdN10esiC0qLHV%25lkp@intel.co=
m/
Link: https://lkml.kernel.org/r/2f1e6a17aaa891ad9c58817cf0a10b8ab8894f59.16=
01565471.git.gustavoars@kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/lib/stackdepot.c~lib-stackdepotc-replace-one-element-array-with-flexi=
ble-array-member
+++ a/lib/stackdepot.c
@@ -62,7 +62,7 @@ struct stack_record {
 	u32 hash;			/* Hash in the hastable */
 	u32 size;			/* Number of frames in the stack */
 	union handle_parts handle;
-	unsigned long entries[1];	/* Variable-sized array of entries. */
+	unsigned long entries[];	/* Variable-sized array of entries. */
 };
=20
 static void *stack_slabs[STACK_ALLOC_MAX_SLABS];
@@ -104,9 +104,8 @@ static bool init_stack_slab(void **preal
 static struct stack_record *depot_alloc_stack(unsigned long *entries, int =
size,
 		u32 hash, void **prealloc, gfp_t alloc_flags)
 {
-	int required_size =3D offsetof(struct stack_record, entries) +
-		sizeof(unsigned long) * size;
 	struct stack_record *stack;
+	size_t required_size =3D struct_size(stack, entries, size);
=20
 	required_size =3D ALIGN(required_size, 1 << STACK_ALLOC_ALIGN);
=20
_

Patches currently in -mm which might be from gustavoars@kernel.org are


