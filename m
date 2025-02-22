Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C94E70823;
	Sat, 22 Feb 2025 00:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740185383; cv=none; b=gZWAXxZofSLqTpCiznVCLUdnkX7C8W4xiYFikyDSV3j8lMpt+GgevKIj9OwJLBJ2SF7dWfOwQ7kC6KK816LUzpLe+tLxBez7MumhEDRefA9Dkookac4UKRRwxpQp0DM5Lz7r3gdoaOAmHElfhxWO/anHOs8GEXH01fauz/9xe7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740185383; c=relaxed/simple;
	bh=nSf3DGrbVEakpJm8sYkqRw9+CCOYiiVFPkIXmF5b6og=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qhKSXbnS8YUZMbKLwfxqZhbEtCdAWV+1HYbMNCTyCcWq1nus88/5gxEudeyNcwpxNBPk2AhCjEVI1GZpjr95YKXakXDeM2sioPvZXgCXR8Y2wccsm4TTJ8hiqTlntaBOKdW3pevu2vPBQu8io2c737bbo2C7yN+g8eBA/P7BUlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=goE2wCKF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="goE2wCKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EABCC4CED6;
	Sat, 22 Feb 2025 00:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740185382;
	bh=nSf3DGrbVEakpJm8sYkqRw9+CCOYiiVFPkIXmF5b6og=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=goE2wCKF+YhW7HIQexwYbJT5h4y4PxCyj5dPhN2bFlHHWKyEoCWLg4GTW6Ho5L2FN
	 Nm1WWpOJW0VWylR9g/CvMtH1hjO5w8LZkpn3yb3op58Dm6mmPKAS5KmNNtV0tIU31y
	 A75mzTZwMdW1j90tRY0AMgETPzoqe1mvJo2h2rPUjKTbWQQqAoNgpQxakeAS4bzGNF
	 j681AY5r2TUr5rQgyM4Lx5XNY7+z7OHkR6bksWpwlorzgidpaaLQ30I2siDdJBxrTL
	 oTDQ1xi1CNcRPX4OKR4cl3co9VkF53vJrF/6+i2dCCMLxig6S0o4qj4r1hPEbXy0UE
	 XChs6prFcWSBQ==
Date: Sat, 22 Feb 2025 00:49:41 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, wei.liu@kernel.org, tglx@linutronix.de,
	takakura@valinux.co.jp, stable@vger.kernel.org, pmladek@suse.com,
	john.ogness@linutronix.de, jani.nikula@intel.com,
	haiyangz@microsoft.com, gregkh@linuxfoundation.org,
	decui@microsoft.com, bhe@redhat.com,
	hamzamahfooz@linux.microsoft.com
Subject: Re: +
 panic-call-panic-handlers-before-panic_other_cpus_shutdown.patch added to
 mm-nonmm-unstable branch
Message-ID: <Z7kfJZu57WzClVW1@liuwe-devbox-debian-v2>
References: <20250222000008.AAC1BC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250222000008.AAC1BC4CED6@smtp.kernel.org>

Hi Andrew,

On Fri, Feb 21, 2025 at 04:00:08PM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: panic: call panic handlers before panic_other_cpus_shutdown()
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      panic-call-panic-handlers-before-panic_other_cpus_shutdown.patch
> 

Can you please hold off applying this patch? There is an active
discussion on the mailing list. I would like Hamza to answer the
questions there first.

Thanks,
Wei.
