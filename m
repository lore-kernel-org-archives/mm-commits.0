Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFB84F1F1
	for <mm-commits@vger.kernel.org>; Wed, 31 Jan 2024 06:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706683936; cv=none; b=jnPbdIYDfXWVjVleGIsEO85+DOieFDX2CVkceK/xJodyz5pwo9KITlRjlBJCINHkkize7Qquhs1WWruLKWXh/P5IAvNzmmKN0zdCF6BAXLKJhdhkN9fzg6ODwC3BG3DKbbylfKVzZM8TQ4e1YRs80t/h4WlITRD9djL67tAmqiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706683936; c=relaxed/simple;
	bh=kkgs4MpiS4NBzw1bAvWoE6gV/yQrvnfUoqRBtUIZclk=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Tx9IGIGctisCnVTiDF6OznVcqI0u/kJFM8RGGI8MD/ipNoYJNAwSpa7tGO+jB1k5R0wA1nDDa2TerdA9J2VURTUPTzP5JxdG5uPq7wuaQDadLb76I7fydaVXlluCN0+YeT+gzKFQar8QL9+8Xt27Ao/UfydbZf5IKUIbDw4tvyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jq3iervS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jq3iervS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA60C43390;
	Wed, 31 Jan 2024 06:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706683935;
	bh=kkgs4MpiS4NBzw1bAvWoE6gV/yQrvnfUoqRBtUIZclk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Jq3iervSFHKTVS5YkguJF/E+WOkPh11RJc/v8OZqmfjsGvPWlzyD4uDBNqdGyHwpZ
	 kWJ+ONF9k854fbNa6UYVrDcIOo9Odv+QO7BVgmtxUois5XSMZTpModbC8ePcwbWb2d
	 K0GEjSdd/y6u3d3MtmiHFTT4cp1IzxLQ2WnsF+8g=
Date: Tue, 30 Jan 2024 22:51:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: mm-commits@vger.kernel.org, vbabka@suse.cz, mgorman@techsingularity.net
Subject: Re: +
 mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages.patch
 added to mm-unstable branch
Message-Id: <20240130225156.077d0314ee3eae824ac45c42@linux-foundation.org>
In-Reply-To: <e4d47608-7f7f-4156-9fbb-52ffb3029f4d@linux.alibaba.com>
References: <20240130063057.A1891C433C7@smtp.kernel.org>
	<e4d47608-7f7f-4156-9fbb-52ffb3029f4d@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 30 Jan 2024 15:01:30 +0800 Baolin Wang <baolin.wang@linux.alibaba.com> wrote:

> Thanks for queuing this patch, but this patch should be updated as below 
> after the "Enable >0 order folio memory compaction" series:

Best to send a new patch please.
