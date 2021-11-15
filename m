Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E50A2C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 18:38:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D457F6357D
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 18:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242607AbhKOSld (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 13:41:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:44046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242624AbhKOSjF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 13:39:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2135632E9;
        Mon, 15 Nov 2021 18:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636999445;
        bh=RIcspbs4Bc1RuUebJO4f3aIxeSxWrrWxxhpg41zXoGU=;
        h=Date:From:To:Subject:From;
        b=fztr/MLIBGbgORbyjmJTItQLPpq/NO9XCaVXb+qJnEHDckgShkgLsE9avcqABqdNE
         oR7yWM7afVaCraheQ9mIvrYBv/5foJPfnhNJbhvg7UM5il6xX/yQKSCV+4qE1EIkGD
         Vuse5nR6FyXu0h8OoN8B5sn8WfHAL9+NaoElNGRs=
Date:   Mon, 15 Nov 2021 10:04:05 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, axelrasmussen@google.com,
        mm-commits@vger.kernel.org, nadav.amit@gmail.com, peterx@redhat.com
Subject:  + selftests-uffd-allow-eintr-eagain.patch added to -mm
 tree
Message-ID: <20211115180405.K0r3jXHq6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/uffd: allow EINTR/EAGAIN
has been added to the -mm tree.  Its filename is
     selftests-uffd-allow-eintr-eagain.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-uffd-allow-eintr-eagain.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-uffd-allow-eintr-eagain.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: selftests/uffd: allow EINTR/EAGAIN

This allow test to continue with interruptions like gdb.

Link: https://lkml.kernel.org/r/20211115135219.85881-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~selftests-uffd-allow-eintr-eagain
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -644,7 +644,7 @@ static int uffd_read_msg(int ufd, struct
 
 	if (ret != sizeof(*msg)) {
 		if (ret < 0) {
-			if (errno == EAGAIN)
+			if (errno == EAGAIN || errno == EINTR)
 				return 1;
 			err("blocking read error");
 		} else {
@@ -720,8 +720,11 @@ static void *uffd_poll_thread(void *arg)
 
 	for (;;) {
 		ret = poll(pollfd, 2, -1);
-		if (ret <= 0)
+		if (ret <= 0) {
+			if (errno == EINTR || errno == EAGAIN)
+				continue;
 			err("poll error: %d", ret);
+		}
 		if (pollfd[1].revents & POLLIN) {
 			if (read(pollfd[1].fd, &tmp_chr, 1) != 1)
 				err("read pipefd error");
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-uffd-allow-eintr-eagain.patch

