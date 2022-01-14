Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 532FBC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:08:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbiANWIF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:08:05 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:37558 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiANWIF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:08:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 13421CE2497
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:08:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C3EC36AE9;
        Fri, 14 Jan 2022 22:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198082;
        bh=U69HfuOa+YONiguT5W5kkfMrpQWWUFeHxAKhMreztxo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Bt70inFZBzwoQZaepBGeIemirUALYdtcFE/mem722BeEPMuciqd1rhw8kSECo7FXl
         WnlRwReGKgVKHUHtQ+57GhSv+KVBfYG8d8mN6omgKwtdbOV0FDjGFtwN7BKBpq66Jf
         TxK3QrEA7w+tg7jnzg9PU/PECH7IYHKrzTaiEwIg=
Date:   Fri, 14 Jan 2022 14:08:01 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        axelrasmussen@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, nadav.amit@gmail.com,
        peterx@redhat.com, torvalds@linux-foundation.org
Subject:  [patch 092/146] selftests/uffd: allow EINTR/EAGAIN
Message-ID: <20220114220801.vRTCklHUU%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -648,7 +648,7 @@ static int uffd_read_msg(int ufd, struct
 
 	if (ret != sizeof(*msg)) {
 		if (ret < 0) {
-			if (errno == EAGAIN)
+			if (errno == EAGAIN || errno == EINTR)
 				return 1;
 			err("blocking read error");
 		} else {
@@ -724,8 +724,11 @@ static void *uffd_poll_thread(void *arg)
 
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
