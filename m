Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974CF28DD0
	for <mm-commits@vger.kernel.org>; Fri, 22 Dec 2023 17:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ARmq0tos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073BAC433C7;
	Fri, 22 Dec 2023 17:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703267926;
	bh=hsAzezM55RYrpAHeXu+Fz83UA5RLPxKNFPEhKfYsN5Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ARmq0tosdlw90yh3QGe5KDzJXvSfC62a3c6rX/UwqsO+5uAQomrw8iKKmHZoG73f3
	 n2+M5zzwf/cH+Izx+EGxneaY1RPCczCbyZBREGS8ezU6NNPFDSCDIbVLbkTNQBEnSW
	 eper0ySgzi2sdk92J/xCtdvSCUX3WXq5GSpoSRSk=
Date: Fri, 22 Dec 2023 09:58:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: mm-commits@vger.kernel.org, "Stephen Rothwell" <sfr@canb.auug.org.au>,
 "David S . Miller" <davem@davemloft.net>, "Andreas Larsson"
 <andreas@gaisler.com>
Subject: Re: +
 arch-sparc-fix-up-fallout-from-enabling-wmissing-prototypes.patch added to
 mm-nonmm-unstable branch
Message-Id: <20231222095845.139dfd55d457fd126b862a73@linux-foundation.org>
In-Reply-To: <ce68eb27-420b-467f-8b1a-e285b94bba79@app.fastmail.com>
References: <20231222062640.70D05C433C9@smtp.kernel.org>
	<ce68eb27-420b-467f-8b1a-e285b94bba79@app.fastmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 22 Dec 2023 10:29:28 +0000 "Arnd Bergmann" <arnd@arndb.de> wrote:

> 
> I don't think there are any build errors after commit 0f0d2871e78d
> ("arch: turn off -Werror for architectures with known warnings"),
> which you have merged already.

allmodconfig turns on -Werror so sparc64 allmodconfig has failures all
over the place.

> These are fixed in the asm-generic tree by making the functions
> 'static __used', same as on other architectures, so I would suggest
> dropping this hunk to avoid conflicts between the two patches.
> 
> The other changes look good to me. 

I'll drop the whole thing - please pick out any useful bits.
