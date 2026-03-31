Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFEED7E792
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774916839; cv=none; b=PrVSSKr5+3Kdm5jtjf4JeMnOpiAGyq+LZQYny+QzNb904+Ow6MgZbvpOZ+fS3pKGVoNSooUdzULXEp51oshubYpBHJlzw0X0ujfY9hiZDSDuSVmVio4wNOeI6MaFRh/2smyOvorJ9IvDW1klzkPx8OOcj4TmW2S/a7+MkjutAlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774916839; c=relaxed/simple;
	bh=1vGfp4IxmKADislMJMsqpIk8nYUaVXyZrLoYMfHZwdU=;
	h=Date:From:To:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=aH4C/cTgnAMTKca6UgeDnHtqfGGPhphLIFSqA6vpBIAsIAE4JvjMyfP//sIjUtzPJB6J0133lO0NcYraF33OYe6dh76t/N5WxUGjWpHtRW4gydIDHVFB7eeqXWm4ws8mFz+o9ol59eZWYN/AxFR28YZbVGWBEJbw3aFcR0xlbuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NPAOcxbJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NPAOcxbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B6FC4CEF7;
	Tue, 31 Mar 2026 00:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774916839;
	bh=1vGfp4IxmKADislMJMsqpIk8nYUaVXyZrLoYMfHZwdU=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=NPAOcxbJh2UzEQY3nfKhrxPWm/PaG73euccMTLfJkdFQNmrwDUPwQeBQa7BelFZ/a
	 U7cFOf5A6mLkZFEXsV8WGdCsEZqxvVW+X77jcc315vBhnJdDJgFPQrCfSuRDtA4UoZ
	 JSuhWN+OcWBaU+ZxoF4mM/0tkEecZ1uF9Cbri06c=
Date: Mon, 30 Mar 2026 17:27:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mm-commits@vger.kernel.org, ljs@kernel.org
Subject: Re: +
 selftests-mm-add-merge-test-for-partial-msealed-range-fix.patch added to
 mm-new branch
Message-Id: <20260330172718.de8046166d28cbd4cf80ad43@linux-foundation.org>
In-Reply-To: <20260331001703.6C7EDC4CEF7@smtp.kernel.org>
References: <20260331001703.6C7EDC4CEF7@smtp.kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 30 Mar 2026 17:17:02 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> ---
> 
>  tools/testing/selftests/mm/merge.c      |    1 +
>  tools/testing/selftests/mm/mseal_test.c |    1 +
>  2 files changed, 2 insertions(+)
> 
> --- a/tools/testing/selftests/mm/mseal_test.c~selftests-mm-add-merge-test-for-partial-msealed-range-fix
> +++ a/tools/testing/selftests/mm/mseal_test.c
> @@ -8,6 +8,7 @@
>  #include <sys/time.h>
>  #include <sys/resource.h>
>  #include <stdbool.h>
> +#include <unistd.h>
>  #include "kselftest.h"
>  #include <syscall.h>
>  #include <errno.h>

oops, that hunk isn't supposed to be there.

> --- a/tools/testing/selftests/mm/merge.c~selftests-mm-add-merge-test-for-partial-msealed-range-fix
> +++ a/tools/testing/selftests/mm/merge.c
> @@ -6,6 +6,7 @@
>  #include <fcntl.h>
>  #include <stdio.h>
>  #include <stdlib.h>
> +#include <asm-generic/unistd.h>
>  #include <unistd.h>
>  #include <sys/mman.h>
>  #include <sys/prctl.h>
