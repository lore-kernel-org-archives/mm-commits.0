Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347333368A0
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 15:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777303706; cv=none; b=ak2n/J1vjTIi+MM7cVNgRTnnxEFvbEUaw1v1cXrhl7bVs5/TXuwLkaznDSuBWLcw8b3dn/xBMkX3s4p57BrRaIMDp9e8ngdRXk0hlHjBTeKeB0TNTZuZwD2XMHCghoW6locnG+lnL/rx0M2ciP+j3U/2EC19WyVby+9OyXmSTwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777303706; c=relaxed/simple;
	bh=Z0IYTNIl7imYUvG3+z6cISaensoUAq5ybM/XpZCcCEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mk+PgFnF3Vo3KTeNKuJMgS7xNxvE+6YOYynOT6zkuCdq4GZ+c888sxC+ZqYJQtz+ssEDfcPU23NCz+Uv5WmPg92+lVpgBsvl1ZHjjSh/a+gJOpDqD+EwuY/biyBCEL05tpy3Lz5Vnr7ttpRyUZLbs2ffqEfYZanNMzBboOkdkLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qZiQ3pn2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qZiQ3pn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD394C19425;
	Mon, 27 Apr 2026 15:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777303705;
	bh=Z0IYTNIl7imYUvG3+z6cISaensoUAq5ybM/XpZCcCEQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qZiQ3pn2MtheaHp+s4/jH0GRgY+W/rIct28jMXeXZXlckkErOnMuSFlsjyHrQi5pG
	 yNgXpKvA4Yd2SO4+zDDixbmHu4bu33pplvGZUqyIS7zeiFN21As03sv4PkIE+cqtb6
	 Z0HxYShOS58rhokpKhCXhPZI/wgyYd9B0duNpLgud1JGJIo0+7MdVRrgXtYPNU4w10
	 0ry9Q6mUcIBGp6qjoUzbC6o7+zBa0bNyctAwWg7YFVbc+TU1/z7sZV+++HYXveMH7X
	 WjrGr2c2sLzSs0Sr78SOHP2cOWhdSjf9iYY+t3NHedwfCq08C7YB6iajaanCbkbJn7
	 XGt3rn7IW1s7A==
Date: Mon, 27 Apr 2026 17:28:21 +0200
From: Christian Brauner <brauner@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, 
	skhan@linuxfoundation.org, jack@suse.cz, corbet@lwn.net, broonie@kernel.org, 
	emanuele.rocca@arm.com
Subject: Re: + coredump-add-core_pattern-specifier-for-si_code.patch added to
 mm-nonmm-unstable branch
Message-ID: <20260427-gemein-wirkung-4cd5541888de@brauner>
References: <20260425170913.63E9CC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260425170913.63E9CC2BCB0@smtp.kernel.org>

On Sat, Apr 25, 2026 at 10:09:12AM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: coredump: add core_pattern specifier for si_code
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      coredump-add-core_pattern-specifier-for-si_code.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/coredump-add-core_pattern-specifier-for-si_code.patch
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
> The -mm tree is included into linux-next via various
> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there most days
> 
> ------------------------------------------------------
> From: Emanuele Rocca <emanuele.rocca@arm.com>
> Subject: coredump: add core_pattern specifier for si_code
> Date: Tue, 17 Mar 2026 16:00:06 +0100
> 
> The specifiers supported by core_pattern include the option to indicate
> the signal number si_signo by using %s.  Other than identifying which
> signal generated a core dump (eg: 11 for SIGSEGV), it is useful to know
> the reason why a certain signal was sent.  The signal code si_code (eg: 2
> for SEGV_ACCERR) provides this information.
> 
> Adding the signal code to core_pattern can benefit in particular sysadmins
> who pipe core dumps to user-space programs for later analysis. 
> systemd-coredump(8) is a notable example of such programs.
> 
> Link: https://lore.kernel.org/ablsdmLsMKm0z5wt@NH27D9T0LF
> Signed-off-by: Emanuele Rocca <emanuele.rocca@arm.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

commit 701f7f4fbabbf4989ba6fbf033b160dd943221d5
Author:     Emanuele Rocca <emanuele.rocca@arm.com>
AuthorDate: Mon Mar 23 14:02:16 2026 +0100
Commit:     Christian Brauner <brauner@kernel.org>
CommitDate: Mon Mar 23 16:29:15 2026 +0100

    pidfds: add coredump_code field to pidfd_info

Is merged upstream. Two things:

(1) I've clarified that the si_code is supposed to be exposed via the
    pidfd and so it has been done. The funneling of endless arguments
    via this procfs file will stop.

(2) Andrew, I've reworked fs/coredump.c completely and I'll route
    patches as part of the vfs trees. Please just ping me in case I
    don't get notified somehow.

In any case, patch upstream. This should be dropped.
