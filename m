Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C03370AE7
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027629; cv=none; b=o2TFKcrcb/Zzu8cZR5EbBTuxXB9DwtnlXMt87ZzR1/mPH8b2BXybKgHcfMbWkkVgx3WgfFca9YBf9S0b0C4SwdwcQVFaUH2tMip6H569VaRS79kRvA0UMn6cdQPxtdWS6KeNnpx6VaRwcZc2hNCSp3AT6m3L9bxCgZ5CzKs5K4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027629; c=relaxed/simple;
	bh=q7sciMpjurV1OH3/4e6laJkEpYFEqySVudt8MW7sJjs=;
	h=Date:To:From:Subject:Message-Id; b=f9N7VYgWUCiOY02pePM3Q2Ejq5hOJRgM0nBhBdyYaFfjszT34junV5BScO3vqK15qtFDxnBsKTIXW/KfJwKbrVRtADEqohbnPLSxMCRMAFZWp3qGoUgCnBABgJmWFF/4kspf0Gi6P8OeoxWBX2L4nwP2kKvMXBIoWIxZcRtTszI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y4Dow6fc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y4Dow6fc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8DA1F00898;
	Fri, 29 May 2026 04:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027628;
	bh=Q/qlES++QXI/vnYeDyH9vyuoySCrBFLkt0xZvaYfh8E=;
	h=Date:To:From:Subject;
	b=y4Dow6fcy3zb8ZvJAo8yPvNTBoQElhbVaUmyIVkpRCU2LEDWYw/WunV/tCSVHB77r
	 NRJI7NUpqj1W/hMoE31clBpSCfil5B4Hp5LTAf1aaKN6BtGvJ+7nDEFqwvlUHWVUJk
	 4BvJsPinbNsoeucBHM38LCKVfC9Es7xKMwOU2UBk=
Date: Thu, 28 May 2026 21:07:07 -0700
To: mm-commits@vger.kernel.org,tzimmermann@suse.de,stf_xl@wp.pl,pabeni@redhat.com,mripard@kernel.org,maarten.lankhorst@linux.intel.com,kuba@kernel.org,horms@kernel.org,glider@google.com,elver@google.com,edumazet@google.com,dvyukov@google.com,davem@davemloft.net,allison.henderson@oracle.com,airlied@gmail.com,achender@kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] net-rds-use-special-gfp_t-format-specifier.patch removed from -mm tree
Message-Id: <20260529040707.EB8DA1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: net/rds: use special gfp_t format specifier
has been removed from the -mm tree.  Its filename was
     net-rds-use-special-gfp_t-format-specifier.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-introduce-for_each_free_list.patch
mm-page_alloc-dont-overload-migratetype-in-find_suitable_fallback.patch
mm-rejig-pageblock-mask-definitions.patch
mm-page_alloc-remove-ifdefs-from-pindex-helpers.patch
mm-page_alloc-drop-a-misleading-__always_inline.patch
mm-page_alloc-document-that-alloc_pages_nolock-uses-rcu.patch
mm-page_alloc-remove-vm_bug_ons-from-pindex-helpers.patch

