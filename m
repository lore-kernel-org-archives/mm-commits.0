Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305822512D7
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 19:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754161347; cv=none; b=iSpo5Tn6VNvtZai+OG7JLPDrd09g53dnlN3FmiIj4//Fyj9RcOT5IWl39EvgbXUNyfgXspGLpbPmXpw7MdSwu7txa2NpPC7w+TwjG1XBVH+b6/MlWTN2Wvc8TfhcJtJMCDWyysQyiKt0N+5E8pR3arsDqkhuJapuoUTmhATMcvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754161347; c=relaxed/simple;
	bh=JNlNTwFK+Dkkfus9K28naXoUM6FzS3KhySRsH2ivPXY=;
	h=Date:To:From:Subject:Message-Id; b=ajWERnqr4opfZj7o0cyPRqf6KB97T0BwvH67gBn4YM7OOhD7gUf13lPhaGfYzHpdZuaKju+HH1UdCjBg4V4MKYWMQTuw4GVZYcqAkohG968nlfWDNCZfZl8Vu7+DZkORr4TBSdueU+uUzZRPpbwuWspqxu/aqnGEo1gk+OTno1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NeKVQVCf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NeKVQVCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF2BC4CEEF;
	Sat,  2 Aug 2025 19:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754161346;
	bh=JNlNTwFK+Dkkfus9K28naXoUM6FzS3KhySRsH2ivPXY=;
	h=Date:To:From:Subject:From;
	b=NeKVQVCfD2E02vh8KJgqbZGb2ZJri5fUPZGSTK4TkMXrvyjviEa1pipKM3nkeP7Uu
	 cM/fyxddLWECQ563PE0F/+DsONdNbwgPcxZOfTXIFKZKaZL0z/sJ4fug7T/30gceQt
	 VS7+qD0G+cLviD1KbGYemobIORo25j7S2LrPfl9U=
Date: Sat, 02 Aug 2025 12:02:26 -0700
To: mm-commits@vger.kernel.org,horms@kernel.org,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] net-mvneta-fix-typo-notifer.patch removed from -mm tree
Message-Id: <20250802190226.DBF2BC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: net: mvneta: fix typo "notifer"
has been removed from the -mm tree.  Its filename was
     net-mvneta-fix-typo-notifer.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: WangYuli <wangyuli@uniontech.com>
Subject: net: mvneta: fix typo "notifer"
Date: Tue, 22 Jul 2025 15:34:27 +0800

There is a spelling mistake of 'notifer' in the comment which
should be 'notifier'.

Link: https://lkml.kernel.org/r/0CB4300CB6F49007+20250722073431.21983-4-wangyuli@uniontech.com
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/marvell/mvneta.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/mvneta.c~net-mvneta-fix-typo-notifer
+++ a/drivers/net/ethernet/marvell/mvneta.c
@@ -4610,7 +4610,7 @@ static int mvneta_stop(struct net_device
 		/* Inform that we are stopping so we don't want to setup the
 		 * driver for new CPUs in the notifiers. The code of the
 		 * notifier for CPU online is protected by the same spinlock,
-		 * so when we get the lock, the notifer work is done.
+		 * so when we get the lock, the notifier work is done.
 		 */
 		spin_lock(&pp->lock);
 		pp->is_stopped = true;
_

Patches currently in -mm which might be from wangyuli@uniontech.com are


