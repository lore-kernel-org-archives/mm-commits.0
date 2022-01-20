Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA69CC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377861AbiATV06 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:26:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58210 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377863AbiATV06 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:26:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22CCCB81E69
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F79C340E0;
        Thu, 20 Jan 2022 21:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714015;
        bh=jK4u2IJdRBBQJwdBjY4pIf0JPLNAwdH+UdqyFXpbmH4=;
        h=Date:From:To:Subject:From;
        b=S92S2TY8zPrO1TqDfCD67umrMQAywArVldMAZsppQ6GMA+7O+V68BpvRa93zq4sY9
         UW1H9ti8w6QxwWhquOIPhj/wv1BehV5uAqCd7SwS7ZCbdGC412rP+rVbYFuOMIYD0H
         HX2L0cjHZs8OFg2T7jmcyXiYMHhmkilVtM2JoyGc=
Date:   Thu, 20 Jan 2022 13:26:55 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, axelrasmussen@google.com,
        mm-commits@vger.kernel.org, nadav.amit@gmail.com, peterx@redhat.com
Subject:  [merged] selftests-uffd-allow-eintr-eagain.patch removed
 from -mm tree
Message-ID: <20220120212655.o6h88hKzG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/uffd: allow EINTR/EAGAIN
has been removed from the -mm tree.  Its filename was
     selftests-uffd-allow-eintr-eagain.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from peterx@redhat.com are


