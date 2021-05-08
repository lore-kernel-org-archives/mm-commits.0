Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB948C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C326A61432
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhEHWyc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:54:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229567AbhEHWyb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:54:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95DBD6142D;
        Sat,  8 May 2021 22:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514408;
        bh=M3GfQ+qR77TO2sYAg9aspescKQJhBjtezb05IZjoxPE=;
        h=Date:From:To:Subject:From;
        b=06SIek0BUP+YLpxaHPNBqgOSbcCS7pTCmA4/zJ/DuoCYMmXNh249AKJmxVxW0Rvzg
         KHRcuiOlLMan9WvpUY8NqzYhMjbqe8pNxQi3ZD6Uv62D2vIhd4SB5jb+jh8APr5u/Z
         XuX/JoWWMqMVuD5gwISIql6WS1vRukEmZqt+PNbA=
Date:   Sat, 08 May 2021 15:53:28 -0700
From:   akpm@linux-foundation.org
To:     gustavoars@kernel.org, mikulas@artax.karlin.mff.cuni.cz,
        mm-commits@vger.kernel.org
Subject:  [merged]
 hpfs-replace-one-element-array-with-flexible-array-member.patch removed
 from -mm tree
Message-ID: <20210508225328.kDGCAU-Rq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hpfs: replace one-element array with flexible-array member
has been removed from the -mm tree.  Its filename was
     hpfs-replace-one-element-array-with-flexible-array-member.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: "Gustavo A. R. Silva" <gustavoars@kernel.org>
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

