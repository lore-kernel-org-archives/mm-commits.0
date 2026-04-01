Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2B437C10E;
	Wed,  1 Apr 2026 04:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775018325; cv=none; b=FEfyJO7gGFnonOO/Zm6Q0YaCATQMVWcfMzF7x1HWNsV4NNReLhzXNmvI81V1AzuNEjkIdmahu3XKPS3gdPk+jiJaqc3+xiDE7l8p/IRiX9XIdwslJP7IvvDQpgBtkKKTu28sNpaHHpCQ0OL26JGWfklfg1TTUzcIpdoqaD1emGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775018325; c=relaxed/simple;
	bh=Pe8yzmyK74QmJ6YFiyq2nFSa7nHlhrhYjgvLMrGfkVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z50F4wGNj8o0O07KCdTaPvYhyMcdAEOnU+TxkXwSejHXQWqu28oET9EUOySOj7q5bDDVVyPDt2Yxj6418i1lWEH0rXmZ8b29WrbqrjPdkkaaeGkE6eFt3LJPJmzHh5ML8ObahLghzTJ0Bu/XbX+UsxOf0exFrmpT4ergmcfKZVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L5XnYEBD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L5XnYEBD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24AE8C4CEF7;
	Wed,  1 Apr 2026 04:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775018325;
	bh=Pe8yzmyK74QmJ6YFiyq2nFSa7nHlhrhYjgvLMrGfkVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5XnYEBD/jK1EIjLXBL26UjYGIin+n3lxSIOY7vKAM7xvtmEms4a0Dn7TL17q0veI
	 XbJ76ddGqczpiBZ+VfKzXWOPYFENTDqEpsIcmUzNYcS1A6rz3LL8F6/5M/sqp8wE6a
	 m/Yc1Ppy/m9KKEe2/2trg18pKidps/BmrsP3nVXXegLjEitmwpAgmHvt64+6vwtz96
	 wR4gM9unRsNr14q00KEc9uBNEc771vX7Q+GuVZ5sYc9m7zga2BvmGnVdeVeQcSJY68
	 Mni5Fj2+4UnqL9XUSBQZfAr8Drpe1hojJlnv59vYJ/v9m1DQ9gGRvobLc14J+R33An
	 C9blLUVaVxrBw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	mm-commits@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: + mm-damon-core-validate-damos_quota_goal-nid-for-node_mem_usedfree_bp.patch added to mm-hotfixes-unstable branch
Date: Tue, 31 Mar 2026 21:38:43 -0700
Message-ID: <20260401043843.23448-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401033151.CB9DAC4CEF7@smtp.kernel.org>
References: 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello Andrew,

On Tue, 31 Mar 2026 20:31:51 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> The patch titled
>      Subject: mm/damon/core: validate damos_quota_goal->nid for node_mem_{used,free}_bp
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      mm-damon-core-validate-damos_quota_goal-nid-for-node_mem_usedfree_bp.patch
[...]
> ------------------------------------------------------
> From: SeongJae Park <sj@kernel.org>
> Subject: mm/damon/core: validate damos_quota_goal->nid for node_mem_{used,free}_bp
> Date: Sat, 28 Mar 2026 21:38:59 -0700
> 
> Patch series "mm/damon/core: validate damos_quota_goal->nid".
> 
> node_mem[cg]_{used,free}_bp DAMOS quota goals receive the node id.  The
> node id is used for si_meminfo_node() and NODE_DATA() without proper
> validation.  As a result, privileged users can trigger an out of bounds
> memory access using DAMON_SYSFS.  Fix the issues.
> 
> The issue was originally reported [1] with a fix by another author.  The
> original author announced [2] that they will stop working including the
> fix that was still in the review stage.  Hence I'm restarting this.
> 
> 
> Users can set damos_quota_goal->nid with arbitrary value for
> node_mem_{used,free}_bp.  But DAMON core is using those for
> si_meminfo_node() without the validation of the value.  This can result in
> out of bounds memory access.  The issue can actually triggered using DAMON
> user-space tool (damo), like below.

Seems "This patch (of X):" line before the above paragraph is missed.


Thanks,
SJ

[...]
