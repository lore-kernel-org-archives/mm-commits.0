Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D508D512
	for <mm-commits@vger.kernel.org>; Fri,  4 Oct 2024 02:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728007559; cv=none; b=Pvisnp1KEtnNkINjz4rv6NoFF5DuyjXd8Wx3StFdSC59MuWa8Gfg/eoIs4Bwgw82a102wOLYMA2osT9EZNOaHL2o9Yof0Ngog1CfFCdnugDdsTXLRyl4VJGMytr6ECF6OxLTfwQ2mme0WYRRnpcniBlYBoIMyY5ASQP7cvxHyGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728007559; c=relaxed/simple;
	bh=u3YiS9q/wlyxu7D+oFGKPz/cpwLR3lIorUClZJAZgw0=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=QgSwlD5pnK9wCiDT0//lGBuj07b0qoRIKdI5p+5IqHEIx+4lWddB9S3bXnt1lPUuimx4rb99OEN9KBb+vMsdtrzmedU5vSKNDUoQ8cgh08q7r2BzMoPExLnr4LCSvHrhtIAcWbrimbONYrL4k+9nf+vwjDk02Shh4kPfj8vQIpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WeTS+CJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WeTS+CJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8DFC4CEC5;
	Fri,  4 Oct 2024 02:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728007559;
	bh=u3YiS9q/wlyxu7D+oFGKPz/cpwLR3lIorUClZJAZgw0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WeTS+CJf0Exb2LYGwYc8EdPc8hdhVkJVNUdvlwnPEa+Sh3OvSNOAzC3miwTLcy/Qn
	 b5W6L9POkb2TFFfSkH7vnbJvGgxov1Xlp3rLIjWVU1IEKYZwTPLw/Heh02OuBeu5al
	 ldEs4xp02idU9SJzKeAmPNWluKCYyv092hfxOIi0=
Date: Thu, 3 Oct 2024 19:05:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: mm-commits@vger.kernel.org, tj@kernel.org, dennis@kernel.org,
 aha310510@gmail.com
Subject: Re: [failures]
 mm-percpu-fix-typo-to-pcpu_alloc_noprof-description.patch removed from -mm
 tree
Message-Id: <20241003190558.59cd6d6db9cf0a5549e1e7e0@linux-foundation.org>
In-Reply-To: <e91916d5-b712-0920-9b18-0a643cc46c74@gentwo.org>
References: <20241003192838.790ABC4CEC5@smtp.kernel.org>
	<e91916d5-b712-0920-9b18-0a643cc46c74@gentwo.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 3 Oct 2024 16:15:38 -0700 (PDT) "Christoph Lameter (Ampere)" <cl@gentwo.org> wrote:

> On Thu, 3 Oct 2024, Andrew Morton wrote:
> 
> > This patch was dropped because it had testing failures
> 
> A change to a comment causes testing failures? Really?

yup,
https://lkml.kernel.org/r/202409250728.jWiBpk6e-lkp@intel.com

also
https://lkml.kernel.org/r/3cbe26aa-1f6c-48c3-ad5e-203c98333dab@suse.cz
which I didn't 100% understand, but makes me suspect a new patch is needed.
