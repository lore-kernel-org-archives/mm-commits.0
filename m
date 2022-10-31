Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97299FA3741
	for <mm-commits@archiver.kernel.org>; Mon, 31 Oct 2022 20:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiJaUIe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Oct 2022 16:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiJaUId (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2022 16:08:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2460F10
        for <mm-commits@vger.kernel.org>; Mon, 31 Oct 2022 13:08:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C3F460C25
        for <mm-commits@vger.kernel.org>; Mon, 31 Oct 2022 20:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982B7C433C1;
        Mon, 31 Oct 2022 20:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667246909;
        bh=hJPkRaZsf0SnB/JWXU12THDf+QlGekjaz47zqu2TxQ8=;
        h=Date:To:From:Subject:From;
        b=RaoxDXSv/17fJfPe7f4Mu9NLBELogzWnkqqfoMBei0sbGsmAoKVVPZ2pC9zSMGJ/I
         IcXvIgI/Y4kLDrZsE5ElKfqj523O7zFIp8fQjJiuJMg7/19GCe+jAX0RT1bKrO0Enb
         d2l59AzNrsEfcqhkvvBXof0f4Muk4ylvXSZLXj2Q=
Date:   Mon, 31 Oct 2022 13:08:28 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu,
        siddhesh@gotplt.org, oliver.sang@intel.com, miklos@szeredi.hu,
        dhowells@redhat.com, cmaiolino@redhat.com, raven@themaw.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] ext4-fix-possible-null-pointer-dereference.patch removed from -mm tree
Message-Id: <20221031200829.982B7C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ext4: fix possible null pointer dereference
has been removed from the -mm tree.  Its filename was
     ext4-fix-possible-null-pointer-dereference.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Ian Kent <raven@themaw.net>
Subject: ext4: fix possible null pointer dereference
Date: Tue, 20 Sep 2022 15:26:23 +0800

Patch series "vfs: fix a mount table handling problem", v3.

Whenever a mount has an empty "source" (aka mnt_fsname), the glibc
function getmntent incorrectly parses its input, resulting in reporting
incorrect data to the caller.

The problem is that the get_mnt_entry() function in glibc's
misc/mntent_r.c assumes that leading whitespace on a line can always be
discarded because it will always be followed by a # for the case of a
comment or a non-whitespace character that's part of the value of the
first field.  However, this assumption is violated when the value of the
first field is an empty string.

This is fixed in the mount API code by simply checking for a pointer that
contains a NULL and treating it as a NULL pointer.


This patch (of 2):

It could be the case that the file system parameter ->string value is NULL
rather than a zero length string.

Guard against this possibility in ext4_parse_param().

Link: https://lkml.kernel.org/r/166365872189.39016.10771273319597352356.stgit@donald.themaw.net
Link: https://lkml.kernel.org/r/166365878336.39016.10934709128005232231.stgit@donald.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Reported-by: kernel test robot <oliver.sang@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Siddhesh Poyarekar <siddhesh@gotplt.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/super.c~ext4-fix-possible-null-pointer-dereference
+++ a/fs/ext4/super.c
@@ -2099,12 +2099,12 @@ static int ext4_parse_param(struct fs_co
 	switch (token) {
 #ifdef CONFIG_QUOTA
 	case Opt_usrjquota:
-		if (!*param->string)
+		if (!param->string || !*param->string)
 			return unnote_qf_name(fc, USRQUOTA);
 		else
 			return note_qf_name(fc, USRQUOTA, param);
 	case Opt_grpjquota:
-		if (!*param->string)
+		if (!param->string || !*param->string)
 			return unnote_qf_name(fc, GRPQUOTA);
 		else
 			return note_qf_name(fc, GRPQUOTA, param);
_

Patches currently in -mm which might be from raven@themaw.net are

vfs-parse-deal-with-zero-length-string-value.patch

