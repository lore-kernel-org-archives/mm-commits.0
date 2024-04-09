Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3C8159208
	for <mm-commits@vger.kernel.org>; Tue,  9 Apr 2024 23:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712706991; cv=none; b=ev9Ek6/aEIKZZPDBnGHUdpbbeff2o4FpQAXJdP64deuPl+1gJKp2jaDUb5i+utdknxjs+HY50QIVn1VP7w7DCHr+uHdIz+wyM2n9xOjt2nI8xNXwwSNroQRS5/kcgG9++CYK/363bIxiyM93bskhuVQ8YpsT6gsol33PambOBz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712706991; c=relaxed/simple;
	bh=3K5p4IiVRLnZ1jTMzXVL26/YjIYrApV8ePF9irY6c2A=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=tWcH0iBK5EkHupnaaIIxAqAgTtuOujO81JKW/O2HiFy9nVgbdOpqPUZ4wgA7tozSR9ll1R0laTQ9WtK7nQ4/ThLGV5r0ygaH5Dskvqs1BVoWDNhpwO7GOK41dGF8tFVdwE4vlDGeVWobpuYDOKoifKt+ITicAe3r/qcZrZPkvKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gmtr4CDq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gmtr4CDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C70AC433F1;
	Tue,  9 Apr 2024 23:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712706990;
	bh=3K5p4IiVRLnZ1jTMzXVL26/YjIYrApV8ePF9irY6c2A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gmtr4CDq54tAPzWsLhW7CF0iPqrpCLQ2KDHf3Safsbb4oPZMOCe6EDqHDHUdzkeLO
	 tBy3ugFCfC6mZ0Av+qlMIRVlEVsmOIfn3m5rDtNSt6IGYxWCniXIXNoIn8UW0jW9xi
	 UIHP/XI9zsmm2Gxhc897tJaZJbeO3W79/cH/EqOFzMeIYt1xQvpFbSs8snzKqhcQ+X
	 AjbqbrR2eXPGuFsDxQ2Yr8uA7qx8BGZBQTV9kT5n5XYeeNslU1MgB2mk83egfOsyYA
	 vEoFru+kZI38d9J/91JPH35bjMdLrMWT10pvSUoBggOciMFNus9PI0N3pzPezeN9to
	 V5DyclqBzgrrA==
Date: Wed, 10 Apr 2024 08:56:27 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux@rasmusvillemoes.dk
Subject: Re: +
 bootconfig-do-not-put-quotes-on-cmdline-items-unless-necessary.patch added
 to mm-nonmm-unstable branch
Message-Id: <20240410085627.77c36525005364940404ad7d@kernel.org>
In-Reply-To: <20240322002657.D73F4C433C7@smtp.kernel.org>
References: <20240322002657.D73F4C433C7@smtp.kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Andrew,

Can I pick this in my bootconfig/for-next tree?

Thank you,

On Thu, 21 Mar 2024 17:26:57 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> The patch titled
>      Subject: bootconfig: do not put quotes on cmdline items unless necessary
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      bootconfig-do-not-put-quotes-on-cmdline-items-unless-necessary.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bootconfig-do-not-put-quotes-on-cmdline-items-unless-necessary.patch
> 
> This patch will later appear in the mm-nonmm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Subject: bootconfig: do not put quotes on cmdline items unless necessary
> Date: Wed, 20 Mar 2024 11:19:52 +0100
> 
> When trying to migrate to using bootconfig to embed the kernel's and
> PID1's command line with the kernel image itself, and so allowing changing
> that without modifying the bootloader, I noticed that /proc/cmdline
> changed from e.g.
> 
>   console=ttymxc0,115200n8 cma=128M quiet -- --log-level=notice
> 
> to
> 
>   console="ttymxc0,115200n8" cma="128M" quiet -- --log-level="notice"
> 
> The kernel parameters are parsed just fine, and the quotes are indeed
> stripped from the actual argv[] given to PID1.  However, the quoting
> doesn't really serve any purpose and looks excessive, and might confuse
> some (naive) userspace tool trying to parse /proc/cmdline.  So do not
> quote the value unless it contains whitespace.
> 
> Link: https://lkml.kernel.org/r/20240320101952.62135-1-linux@rasmusvillemoes.dk
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  init/main.c |   12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> --- a/init/main.c~bootconfig-do-not-put-quotes-on-cmdline-items-unless-necessary
> +++ a/init/main.c
> @@ -327,7 +327,7 @@ static int __init xbc_snprint_cmdline(ch
>  {
>  	struct xbc_node *knode, *vnode;
>  	char *end = buf + size;
> -	const char *val;
> +	const char *val, *q;
>  	int ret;
>  
>  	xbc_node_for_each_key_value(root, knode, val) {
> @@ -345,8 +345,14 @@ static int __init xbc_snprint_cmdline(ch
>  			continue;
>  		}
>  		xbc_array_for_each_value(vnode, val) {
> -			ret = snprintf(buf, rest(buf, end), "%s=\"%s\" ",
> -				       xbc_namebuf, val);
> +			/*
> +			 * For prettier and more readable /proc/cmdline, only
> +			 * quote the value when necessary, i.e. when it contains
> +			 * whitespace.
> +			 */
> +			q = strpbrk(val, " \t\r\n") ? "\"" : "";
> +			ret = snprintf(buf, rest(buf, end), "%s=%s%s%s ",
> +				       xbc_namebuf, q, val, q);
>  			if (ret < 0)
>  				return ret;
>  			buf += ret;
> _
> 
> Patches currently in -mm which might be from linux@rasmusvillemoes.dk are
> 
> bootconfig-do-not-put-quotes-on-cmdline-items-unless-necessary.patch
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
