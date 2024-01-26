Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8152D2FF
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 06:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706251752; cv=none; b=ZU9oOfdLPyOnfLvtcOl5Yd4CPuZLcs/cSi+H7v9v1rQhdrp9e3osv9sFmq5xQVpYd/ksuCnibPQresia2KjjAsdSW5moud6yUj5wZ6uy6Drgh73fHML5DVz/SV3ip4BlsgujskQBPxua8qT5QYlbJRyTBKQWn/+WJsM8e8SbgNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706251752; c=relaxed/simple;
	bh=q1yvIv7nRn8CPycnzXD37puI1MU+dm7xDV2RgQJTMOQ=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=mPgtwMdYKaYbCNw81fR7XWnjKex9QPAIZFPugNdaqKFWUtKpm25JFWeJMkVXlTlWUVDbk9iQ3bCx6mx7VJ2GMbQ00movUZB7nx+2ryscW78OpiSlbDBRAcIzOgi/PJoClJCvmvpQb3LXFDRrnyIuXnGInNDf7uNAEW0CDwo1kNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yGBRHGJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yGBRHGJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D04C433F1;
	Fri, 26 Jan 2024 06:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706251752;
	bh=q1yvIv7nRn8CPycnzXD37puI1MU+dm7xDV2RgQJTMOQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=yGBRHGJkMd6MoBmNpg7fQGmXi/t4v2+k/tYJe/OT620aDee5hK0Vya+VkMMB4jlCE
	 O7hyPqfTDzZdIaQpVOmPLK10CpD5T6/yO2jX25jWoertEywfefcUk4asS4iQdw1UbL
	 1dGV1TyWM9qktgK6VSzaKlNuAq7+ClLW1Z3GFYVg=
Date: Thu, 25 Jan 2024 22:49:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yosry Ahmed <yosryahmed@google.com>
Cc: mm-commits@vger.kernel.org, shakeelb@google.com,
 roman.gushchin@linux.dev, oliver.sang@intel.com, muchun.song@linux.dev,
 mhocko@kernel.org, hannes@cmpxchg.org
Subject: Re: +
 mm-memcg-optimize-parent-iteration-in-memcg_rstat_updated.patch added to
 mm-hotfixes-unstable branch
Message-Id: <20240125224906.32d5a3939f9133864291ec63@linux-foundation.org>
In-Reply-To: <CAJD7tkYwn30+pahxyVKwWEM50O2rKdMQ33LkQRdpMTnJgOf0_g@mail.gmail.com>
References: <20240126021711.8F67CC433F1@smtp.kernel.org>
	<CAJD7tkYwn30+pahxyVKwWEM50O2rKdMQ33LkQRdpMTnJgOf0_g@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 Jan 2024 20:32:33 -0800 Yosry Ahmed <yosryahmed@google.com> wrote:

> Do you mind correcting this in place: s/O(2+N)/O(1+N)/g? The first
> memcg requires 2 loads, and other memcgs require 1 load, so that's 1+N
> not 2+N.

Done, thanks.
