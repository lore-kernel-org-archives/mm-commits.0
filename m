Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4FC1FBEB0
	for <mm-commits@vger.kernel.org>; Sat, 25 Apr 2026 15:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777129458; cv=none; b=tsn4yV8rIWqyOAlpZ/noPshnDGPbKbmik2lua7Q+T5PqoNa6gppMjdh2qSixSxJ9cVy+7moK1+ZnD0y4018mWqscz8p2r6d/3l+DLsPWPn+2jbMszt4HMdUWdJHmj7R4qM9K+1sBEoQ8eA4hprWcDOulYZ7+2U4lEXbeqK4cVIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777129458; c=relaxed/simple;
	bh=Fbnb1dzux77gIeUycAn4OeLVrPLwjUSe5bHYgB8MaGA=;
	h=Date:To:From:Subject:Message-Id; b=EN9+pw7HgOgzRspsWBgyuBX6CWRMhN9H+ZzdenquBV+rTVzEyyBoPQVY7KhX0PFG1Tj13sglqKbb1DVniG5/zgmiyQlZG4s+a8Kw230BNvbW4FREJwo+JlrYn7qCVP+XdNTCDn2mAyXEwh7OXQLpUntM08O/xZR01ofZwFwmEmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cz9ifkcj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cz9ifkcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CFCC2BCB0;
	Sat, 25 Apr 2026 15:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777129457;
	bh=Fbnb1dzux77gIeUycAn4OeLVrPLwjUSe5bHYgB8MaGA=;
	h=Date:To:From:Subject:From;
	b=cz9ifkcjROU0yV0csOHQ0QikBtzpeskS7HPM4egTvgT8e+eBOkrT7G9xcV6sg6WzQ
	 n3fQKvO1QH+73JgUFcgX7K0N6gu1Heh2ZugUP6mu/HS1eRVwotL3+apSnegsanjB/x
	 /jawDAMieGA0fwQeBhpvi83uiBcqIrAylYGQ3A0w=
Date: Sat, 25 Apr 2026 08:04:17 -0700
To: mm-commits@vger.kernel.org,tzimmermann@suse.de,stf_xl@wp.pl,pabeni@redhat.com,mripard@kernel.org,maarten.lankhorst@linux.intel.com,kuba@kernel.org,horms@kernel.org,glider@google.com,elver@google.com,edumazet@google.com,dvyukov@google.com,davem@davemloft.net,allison.henderson@oracle.com,airlied@gmail.com,achender@kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + net-rds-use-special-gfp_t-format-specifier.patch added to mm-new branch
Message-Id: <20260425150417.A9CFCC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: net/rds: use special gfp_t format specifier
has been added to the -mm mm-new branch.  Its filename is
     net-rds-use-special-gfp_t-format-specifier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/net-rds-use-special-gfp_t-format-specifier.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: net/rds: use special gfp_t format specifier
Date: Thu, 26 Mar 2026 12:32:00 +0000

%pGg produces nice readable output and decouples the format string from
the size of gfp_t.

Link: https://lore.kernel.org/20260326-gfp64-v2-4-d916021cecdf@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Acked-by: Allison Henderson <achender@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Allison Collins <allison.henderson@oracle.com>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Marco Elver <elver@google.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/rds/tcp_recv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/rds/tcp_recv.c~net-rds-use-special-gfp_t-format-specifier
+++ a/net/rds/tcp_recv.c
@@ -275,7 +275,7 @@ static int rds_tcp_read_sock(struct rds_
 	desc.count = 1; /* give more than one skb per call */
 
 	tcp_read_sock(sock->sk, &desc, rds_tcp_data_recv);
-	rdsdebug("tcp_read_sock for tc %p gfp 0x%x returned %d\n", tc, gfp,
+	rdsdebug("tcp_read_sock for tc %p gfp %pGg returned %d\n", tc, &gfp,
 		 desc.error);
 
 	if (skb_queue_empty_lockless(&sock->sk->sk_receive_queue) &&
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-page_alloc-cleanup-flag-vars-in-alloc_pages_bulk_noprof.patch
drm-managed-use-special-gfp_t-format-specifier.patch
mm-kfence-use-special-gfp_t-format-specifier.patch
net-rds-use-special-gfp_t-format-specifier.patch

