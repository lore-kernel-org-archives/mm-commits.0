Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225124A2D;
	Wed, 23 Jul 2025 22:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753310376; cv=none; b=p0MePp7R3m6kjqhd6emLFeS8kJDKkGNZWFH3g90E0ztoE5TloA86uQqbX9FmCsD9YDq9ucKnMh5GJuBP/boxiVwB2XvoIAw1qJyv51xgq6YNGuyXOUTN7NWh+TQ215H24857V3DbpcPkN7dQgYTBfQZ0dbMQ2rljWAReiteZclM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753310376; c=relaxed/simple;
	bh=P9J/VV7e9axpz2DEeGsRPdqwtL7ZkrxKtOOk7OofnAo=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=F0A0zioJRQTRKRyAlzrBilNpmIC5Z0dfXaStG3Rezl1j0fhogfAltJx4jPh0H4lgw1cUHCMlq7SmVZQFk71NyVgk/8oy3B75RFekiCkV0xt9PAk0ORQ60e8RHbP2jWEtlRlThxD9LpOeAGIrNR8RhlzPxKqjPmZeVoOu8k1Qfho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WflWrjbP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WflWrjbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B126C4CEE7;
	Wed, 23 Jul 2025 22:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753310375;
	bh=P9J/VV7e9axpz2DEeGsRPdqwtL7ZkrxKtOOk7OofnAo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WflWrjbP+ekXorFH4uxm6zud90mBtWLtF2E0Pz22hg4cW91rZVX21EM8tNGKJDEcM
	 RZgtVrMqmFuiPrYKNMpe7YZp0MIPauwQ5zl1E9CO1IVGcnRaQxIeEpd8sJPgenauzQ
	 m6Aw9rvO0+JFucAf9I4cQ+ga+qqM3XwOvYwrvCdE=
Date: Wed, 23 Jul 2025 15:39:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: mm-commits@vger.kernel.org, stable@vger.kernel.org,
 senozhatsky@chromium.org, rostedt@goodmis.org, pmladek@suse.com,
 linux@rasmusvillemoes.dk, herbert@gondor.apana.org.au, sfr@canb.auug.org.au
Subject: Re: + sprintfh-requires-stdargh.patch added to mm-hotfixes-unstable
 branch
Message-Id: <20250723153934.0e76b00985dd2bd477b69009@linux-foundation.org>
In-Reply-To: <aID_3hHxWXd1LC5F@smile.fi.intel.com>
References: <20250721211353.41334C4CEED@smtp.kernel.org>
	<aID_3hHxWXd1LC5F@smile.fi.intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 23 Jul 2025 18:29:34 +0300 Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> On Mon, Jul 21, 2025 at 02:13:52PM -0700, Andrew Morton wrote:
> 
> > ------------------------------------------------------
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Subject: sprintf.h requires stdarg.h
> > Date: Mon, 21 Jul 2025 16:15:57 +1000
> > 
> > In file included from drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs_utils.c:4:
> > include/linux/sprintf.h:11:54: error: unknown type name 'va_list'
> >    11 | __printf(2, 0) int vsprintf(char *buf, const char *, va_list);
> >       |                                                      ^~~~~~~
> > include/linux/sprintf.h:1:1: note: 'va_list' is defined in header '<stdarg.h>'; this is probably fixable by adding '#include <stdarg.h>'
> 
> ...
> 
> >  #include <linux/compiler_attributes.h>
> >  #include <linux/types.h>
> > +#include <linux/stdarg.h>
> 
> Can we prevent the ordering?
> 

What do you mean?
