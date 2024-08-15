Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C0378C9C
	for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 21:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723756793; cv=none; b=uZS9bZ4Jl35IJilVOPrZU+mdqQD9WkQB+K5DBQm/zr2h99DFnhynvFSlgzQT2LOThT8j0XxFj4BKr5xCyMwoY5CqSq9hAqWwFmRdyJOvC6VznQgnJMbu8E65VzsuEcgE3d2c2K1WQtbF/79DlBmBFAcahUW88C7vX51SzyEEPjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723756793; c=relaxed/simple;
	bh=OQD4cAU4hpdxFKEx5+tBuweYlMkkFueKygLSg/E9Vdw=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=N2DfmX/vBCB5Agd8DeOmEkW04ukO1m4XJIkvLnhAiNzdJcJTDDLerqQg+vVLSGiM0U1Cl1QIIOyWXIf9s/JUq11SW+JRGbSUHsipIlEF/kqSnRpXuyrUwcyM6Qu56rSgMUGTT/OdW5klSEiKqTMEJ8sjaARWlLe5+1NLpCVlbpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TcgmRFSe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TcgmRFSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F693C32786;
	Thu, 15 Aug 2024 21:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723756793;
	bh=OQD4cAU4hpdxFKEx5+tBuweYlMkkFueKygLSg/E9Vdw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TcgmRFSeR9HahdEBOyqKU1isd4PJc/+05b8uWhE5fzMNMbGKZDdOLqNsCLyMzWXeM
	 JHbz1/ZSCnzcd23YgdrwcFT5u7wu9MgnO/ARuMjtSeC8/CVYvrZTC6FcqzNrESYJp8
	 vqzmtwVt97TkTrJlFp64UiSYN7mUFCqCrVQ4E+QA=
Date: Thu, 15 Aug 2024 14:19:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: mm-commits@vger.kernel.org, ojeda@kernel.org, andreyknvl@gmail.com
Subject: Re: + kasan-simplify-and-clarify-makefile-v2.patch added to
 mm-unstable branch
Message-Id: <20240815141952.4c400e28e50494f34bd3705b@linux-foundation.org>
In-Reply-To: <CANiq72mOivuUg_S5KCmrh71d9Tk49LaaCWjgxLFFNAs3dZWQFA@mail.gmail.com>
References: <20240814202725.5BE36C116B1@smtp.kernel.org>
	<CANiq72mOivuUg_S5KCmrh71d9Tk49LaaCWjgxLFFNAs3dZWQFA@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Aug 2024 15:34:30 +0200 Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:

> Would it be an option to take this through the Rust tree,

Sure, go for it.
