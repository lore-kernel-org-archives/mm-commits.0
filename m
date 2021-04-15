Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44563C433ED
	for <mm-commits@archiver.kernel.org>; Thu, 15 Apr 2021 20:22:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16A2861158
	for <mm-commits@archiver.kernel.org>; Thu, 15 Apr 2021 20:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235348AbhDOUWj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Apr 2021 16:22:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234701AbhDOUWj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Apr 2021 16:22:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE85161131;
        Thu, 15 Apr 2021 20:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618518135;
        bh=hueOhFBZy9kxzBNKTxXKZgRPqYX+nTHJqncS39Wz+ok=;
        h=Date:From:To:Subject:From;
        b=lysNVPfm8x07EPWn+2jpTlAype+5qoykqypVjUni6CSHsl6OS1pj4Ok5ragxjBCS3
         k7W0hrEaIJbJAaT9RB6OAF+5RK0/JEZ61Bn9JcKeB7Sn94kUdUeJd6iCHduY0WlkWx
         I5SQLp67YGqXyHJqR9uZwYH9GRySKDX+NIs0MVIM=
Date:   Thu, 15 Apr 2021 13:22:15 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mikulas@artax.karlin.mff.cuni.cz,
        gustavoars@kernel.org
Subject:  +
 hpfs-replace-one-element-array-with-flexible-array-member.patch added to -mm
 tree
Message-ID: <20210415202215.f693g%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hpfs: replace one-element array with flexible-array member
has been added to the -mm tree.  Its filename is
     hpfs-replace-one-element-array-with-flexible-array-member.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hpfs-replace-one-element-arra=
y-with-flexible-array-member.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hpfs-replace-one-element-arra=
y-with-flexible-array-member.patch

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
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: hpfs: replace one-element array with flexible-array member

There is a regular need in the kernel to provide a way to declare having
a dynamically sized set of trailing elements in a structure. Kernel code
should always use =E2=80=9Cflexible array members=E2=80=9D[1] for these cas=
es. The older
style of one-element or zero-length arrays should no longer be used[2].

Also, this helps with the ongoing efforts to enable -Warray-bounds by
fixing the following warning:

  CC [M]  fs/hpfs/dir.o
fs/hpfs/dir.c: In function `hpfs_readdir':
fs/hpfs/dir.c:163:41: warning: array subscript 1 is above array bounds of `=
u8[1]' {aka `unsigned char[1]'} [-Warray-bounds]
  163 |         || de ->name[0] !=3D 1 || de->name[1] !=3D 1))
      |                                 ~~~~~~~~^~~

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-leng=
th-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/109
Link: https://lkml.kernel.org/r/20210326173510.GA81212@embeddedor
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hpfs/hpfs.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/hpfs/hpfs.h~hpfs-replace-one-element-array-with-flexible-array-mem=
ber
+++ a/fs/hpfs/hpfs.h
@@ -356,7 +356,8 @@ struct hpfs_dirent {
   u8 no_of_acls;			/* number of ACL's (low 3 bits) */
   u8 ix;				/* code page index (of filename), see
 					   struct code_page_data */
-  u8 namelen, name[1];			/* file name */
+  u8 namelen;				/* file name length */
+  u8 name[];				/* file name */
   /* dnode_secno down;	  btree down pointer, if present,
      			  follows name on next word boundary, or maybe it
 			  precedes next dirent, which is on a word boundary. */
_

Patches currently in -mm which might be from gustavoars@kernel.org are

hfsplus-fix-out-of-bounds-warnings-in-__hfsplus_setxattr.patch
hpfs-replace-one-element-array-with-flexible-array-member.patch

