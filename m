Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77CDDC433F5
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 20:50:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EEDF60EDF
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 20:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbhJJUwI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Oct 2021 16:52:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229684AbhJJUwH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 10 Oct 2021 16:52:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC81360F02;
        Sun, 10 Oct 2021 20:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633899009;
        bh=AnquaQ/8acLrtzUjPth+k+wpJrIbBpa5Y0milWFk7P0=;
        h=Date:From:To:Subject:From;
        b=kI+D0KHrXY28aUQ+3bUg9RvXwXZheA3gH5WUFoPqoEwyxwWGi/GpHNUyjUQNUqtxa
         B8vF2jE6Ig33Pfofxn29uhNDE0WHToVnf1A5fhDbYaO5dHnTnKRy8927iKaRCM5Z3V
         mwHa9FobmTL5AkBuAdwXbrtc5EhNgzNMFArtw4lE=
Date:   Sun, 10 Oct 2021 13:50:08 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, colin.king@canonical.com,
        gechangwei@live.cn, ghe@suse.com, jiangqi903@gmail.com,
        jlbec@evilplan.org, junxiao.bi@oracle.com, mark@fasheh.com,
        mm-commits@vger.kernel.org, piaojun@huawei.com
Subject:  +
 ocfs2-dlm-remove-redundant-assignment-of-variable-ret.patch added to -mm
 tree
Message-ID: <20211010205008.W1t8LNa_3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: remove redundant assignment of variable ret
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-remove-redundant-assignment-of-variable-ret.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-remove-redundant-assignment-of-variable-ret.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-remove-redundant-assignment-of-variable-ret.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: ocfs2/dlm: remove redundant assignment of variable ret

The variable ret is being assigned a value that is never read, it is
updated later on with a different value.  The assignment is redundant and
can be removed.

Addresses-Coverity: ("Unused value")
Link: https://lkml.kernel.org/r/20211007233452.30815-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-remove-redundant-assignment-of-variable-ret
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -2698,7 +2698,6 @@ static int dlm_send_begin_reco_message(s
 			continue;
 		}
 retry:
-		ret = -EINVAL;
 		mlog(0, "attempting to send begin reco msg to %d\n",
 			  nodenum);
 		ret = o2net_send_message(DLM_BEGIN_RECO_MSG, dlm->key,
_

Patches currently in -mm which might be from colin.king@canonical.com are

scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch
ocfs2-dlm-remove-redundant-assignment-of-variable-ret.patch
mm-damon-core-nullify-pointer-ctx-kdamond-with-a-null.patch

