Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E12D20C492;
	Wed,  6 Nov 2024 21:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730928612; cv=none; b=rZa8xS6IpGhUViUQ1eiWOrOxMFlFVdV/X7lviVc33mlgkRIdlw55TfIc5NDEWTa2g1tqrJ437m6l2TXGddv3/IcLb0nsEP4oYUR6MsTyFGqTltkPbdlJT1mekLSm0KBdf2+vj1XKeGwcd/77d5rPjlnOvhYiV7CycT8xmnBEOek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730928612; c=relaxed/simple;
	bh=RmLEZGMxswEngGUEe2VuRLiJVrC0w5BMWWTzmp4NN/k=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ZJin7YlU1EOSgFmMKIo81cPRj1chXPX5lEHgw2I7ojVQrjwdkg6ZjqkDIpnz1atFoZE0x6ZcRIXnEbSeJloTuRyRySMpoxRWplAa4G4wEhhPPg9T/Umx4yOsugZk7Tlb5kX3/RCy1BaqlMKk/XJps8nxKkQIV6TQJBAuBSQ0kFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uJyQfSI1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uJyQfSI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D63C4CEC6;
	Wed,  6 Nov 2024 21:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730928612;
	bh=RmLEZGMxswEngGUEe2VuRLiJVrC0w5BMWWTzmp4NN/k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uJyQfSI12V5aWT6dQAkj2eM9NwOeOKrCYVGFFRFUtgEGncWej4VjSkz3Bj5lUWaw0
	 lSNm5XLkkBdddqDk2sdMQBUVXhX41QYCj9+yGX14U2pT5RymKdOc97s/c4+3TnQfMx
	 qDM5IPYKPRIpin+RB+X16dQvltZzRZIYJA1Xh6/0=
Date: Wed, 6 Nov 2024 13:30:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: mm-commits@vger.kernel.org, will@kernel.org, vgupta@kernel.org,
 urezki@gmail.com, tsbogend@alpha.franken.de, tglx@linutronix.de,
 surenb@google.com, song@kernel.org, shorne@gmail.com, rostedt@goodmis.org,
 richard@nod.at, peterz@infradead.org, palmer@dabbelt.com, oleg@redhat.com,
 mpe@ellerman.id.au, monstr@monstr.eu, mingo@redhat.com,
 mhiramat@kernel.org, mcgrof@kernel.org, mattst88@gmail.com,
 mark.rutland@arm.com, luto@kernel.org, linux@armlinux.org.uk,
 Liam.Howlett@oracle.com, kent.overstreet@linux.dev,
 kdevops@lists.linux.dev, johannes@sipsolutions.net, jcmvbkbc@gmail.com,
 hch@lst.de, guoren@kernel.org, glaubitz@physik.fu-berlin.de,
 geert@linux-m68k.org, dinguyen@kernel.org, deller@gmx.de,
 dave.hansen@linux.intel.com, christophe.leroy@csgroup.eu,
 chenhuacai@kernel.org, catalin.marinas@arm.com, bp@alien8.de,
 bcain@quicinc.com, arnd@arndb.de, ardb@kernel.org, andreas@gaisler.com
Subject: Re: [merged mm-stable]
 x86-module-prepare-module-loading-for-rox-allocations-of-text.patch removed
 from -mm tree
Message-Id: <20241106133009.ea62f45c0b7e6b0d400e4a22@linux-foundation.org>
In-Reply-To: <ZysRwR29Ji8CcbXc@kernel.org>
References: <20241106010048.77E63C4CED1@smtp.kernel.org>
	<ZysRwR29Ji8CcbXc@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 6 Nov 2024 08:50:41 +0200 Mike Rapoport <rppt@kernel.org> wrote:

> Hi Andrew,
> 
> Yesterday Nathan discovered and I fixed another small issue with fineibt.
> I suspect it's too late to add this as a fixup, so here's a formal patch
> with the fix.

Thanks.  I only moved this series into mm-stable yesterday so I'll do
the rebase and get this fixup integrated in the cleaner way.

