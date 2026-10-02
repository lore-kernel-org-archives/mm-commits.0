Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF44F43E9D2;
	Fri,  2 Oct 2026 22:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790979402; cv=none; b=FJ+9ookIzDiGCOfAnNi21xcH/IsfvfHUqvaQYg1pIh8Pcyqx424IddYdi9cwVxTjeYCtMCG23fAxdbyWutAmYwGirQj+Aopmtfe8a/QOYY495XBv/JOG01eGTohUr8uOL3qhak51nZa0x2zdGqVgybN4Udjpi9k+UrAPjUduZow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790979402; c=relaxed/simple;
	bh=bgHyRvxdRm2EmCTi8aSiEuilE6BMY2IeCVUd3CzVYhg=;
	h=Date:To:From:Subject:Message-Id; b=N8+z8aNp1amj+V/iHIczPo3TLCdlzXp5xhBri0cZpZEckeQwqeS++tjxUB8CLyM94E02a9P6cvaAyTFOBvptP7P/aHz29CUxR5vh+3x2UH/jVwaPH/o2m37lLtx24jGqr6hpA1EdmafuDCnx6KKC8O6KY4qyy1jSQMaCqCtE0Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xtevqPCE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xtevqPCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D67B1F000FF;
	Fri,  2 Oct 2026 22:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790979400;
	bh=t8Zjuzbzeud5bj3jW6VeBQgyowcXFlqb38tXHDAM6E8=;
	h=Date:To:From:Subject;
	b=xtevqPCEmgIiONC52l6h4/7QsXZn/HsiF29EESKk+x5znQBkDoATBnAW6OzPpgEjN
	 Y6acL3R5bZ7JM4+9Wq2vjtVYKwpl2Hh5DynLUzlUaI2nTTNc7bDniAzFxsw/inWA0p
	 ASFiSg84RIH1oZVEUgvgQAAtj+KMA3S99aaj2P0s=
Date: Fri, 02 Oct 2026 15:16:39 -0700
To: mm-commits@vger.kernel.org,xu.xin@linux.dev,stable@vger.kernel.org,bsingharora@gmail.com,tjdqudcks0424@naver.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] taskstats-restrict-exit-listener-registration-to-init_net.patch removed from -mm tree
Message-Id: <20261002221640.2D67B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: taskstats: restrict exit listener registration to init_net
has been removed from the -mm tree.  Its filename was
     taskstats-restrict-exit-listener-registration-to-init_net.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: 성병찬 <tjdqudcks0424@naver.com>
Subject: taskstats: restrict exit listener registration to init_net
Date: Fri,  2 Oct 2026 07:37:20 +0900

Taskstats exit listeners are stored globally per CPU as bare netlink port
IDs, while exit records are always sent through init_net.  Since commit
edc73c7261ca ("kernel: make taskstats available from all net namespaces"),
a task in the initial user and PID namespaces can register a listener from
a child network namespace.

An unprivileged init_net socket can bind the same namespace-local port ID
and receive another UID task's complete exit record.  Direct taskstats
queries and listener registration by that receiver remain denied with
EPERM.

Reject CPU-mask listener registration and deregistration outside init_net.
Keep PID and TGID queries available from non-initial network namespaces,
preserving the getdelays use case added by the cited commit.

AI-assisted source review helped identify this issue.  The code path,
security boundary, and three reproductions on both v7.2.8 and current
mainline were manually verified in isolated QEMU guests.

Link: https://lore.kernel.org/20261001223721.458667-2-tjdqudcks0424@naver.com
Link: https://lore.kernel.org/all/20110630120831.GB7707@albatros/
Link: https://lore.kernel.org/all/87v8x678ph.fsf@email.froward.int.ebiederm.org/
Fixes: edc73c7261ca ("kernel: make taskstats available from all net namespaces")
Signed-off-by: 성병찬 <tjdqudcks0424@naver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Balbir Singh <balbirs@nvidia.com>
Cc: <bsingharora@gmail.com>
Cc: <xu.xin@linux.dev>
Cc: <stable@vger.kernel.org>
---

 kernel/taskstats.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/taskstats.c~taskstats-restrict-exit-listener-registration-to-init_net
+++ a/kernel/taskstats.c
@@ -454,6 +454,9 @@ static int cmd_attr_cpumask(struct genl_
 	cpumask_var_t mask __free(free_cpumask_var) = CPUMASK_VAR_NULL;
 	int rc;
 
+	if (!net_eq(genl_info_net(info), &init_net))
+		return -EINVAL;
+
 	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
 		return -ENOMEM;
 	rc = parse(info->attrs[attr], mask);
_

Patches currently in -mm which might be from tjdqudcks0424@naver.com are


