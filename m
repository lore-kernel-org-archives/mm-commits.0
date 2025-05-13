Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FB245948
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 23:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747178947; cv=none; b=ogUOVFkOk+A6tXuUGknqkzDE8IlRemzOHPPp3iVX27KxvDurRPlfu2O+92Ck0xTo7X01h0QrLDASCmW9lhaB79IG021ou8TfRmHVeG/zNb54XkGehYiUNKnIB4DPBwmxtaaUXtuDWzve39XK7x4w5yhOlxG84RA3a5/8FI5/afY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747178947; c=relaxed/simple;
	bh=W+THjKz1NI3/bgJuE+9jOn0VPIiMtqmgC/gpsB6cDiI=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=AxJqfaOiOJ3C22YYtHQ8b8jaILzCnEI8ubuKEP5aKZdJ5qYnzmVdyzrkSY/GPjTVLX+TFJLdSjIbLOKoU9kLNRjGx+p/TXmtBuYCRo21DNV9pwgLDlh3jkXcbPUiOCG1216J/tPPqa0qEIHO/9CqjW7Q39AXpH2EDGYGjCg6N6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vfiixCXG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vfiixCXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA258C4CEE4;
	Tue, 13 May 2025 23:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747178947;
	bh=W+THjKz1NI3/bgJuE+9jOn0VPIiMtqmgC/gpsB6cDiI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vfiixCXGD3UmSVzr5TXddij4LXmhua3QsczAC8cTMPpwiXfD5DnoZzTTjzeJ8r0+m
	 MExI4cxkG1dRNNwqiHH+L972NNJ2S/YultH8RLxqGt469tNJR19L5vsWVy++T93Cy3
	 QMfC8dyGP5/1HZ7ZkMMhOF1910RFXUUigsRLV6KQ=
Date: Tue, 13 May 2025 16:29:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: mm-commits@vger.kernel.org, yang.yang29@zte.com.cn,
 wang.yaxin@zte.com.cn, songmuchun@bytedance.com, roman.gushchin@linux.dev,
 muchun.song@linux.dev, mhocko@suse.com, mhocko@kernel.org,
 hannes@cmpxchg.org, david@redhat.com, chen.haonan2@zte.com.cn,
 xu.xin16@zte.com.cn
Subject: Re: [merged mm-stable]
 memcontrol-rename-mem_cgroup_scan_tasks.patch removed from -mm tree
Message-Id: <20250513162906.051a2430ccaa121cb840732e@linux-foundation.org>
In-Reply-To: <36ptbmurx4fwsb5hpbnilojogsdx3fj4f7soywzw6ea4ve4cld@52yyggqaisot>
References: <20250513065531.D8D79C4CEE4@smtp.kernel.org>
	<36ptbmurx4fwsb5hpbnilojogsdx3fj4f7soywzw6ea4ve4cld@52yyggqaisot>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 13 May 2025 08:58:21 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> Hi Andrew, can you please keep this series on hold for now? The
> discussion has not concluded yet. Mainly I want to see system level
> metrics which can get included in memcg and exposed through memory.stat
> interface instead of a new one.

OK, I dropped these from mm-stable so they aren't in mm.git at all. 
Should I re-add these patches to mm-unstable?
