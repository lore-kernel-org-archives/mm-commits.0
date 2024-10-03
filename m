Received: from gentwo.org (gentwo.org [62.72.0.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0A514F124
	for <mm-commits@vger.kernel.org>; Thu,  3 Oct 2024 23:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.72.0.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727997346; cv=none; b=foYLXkGWa/z0clcAhdwrsapRMYkowklhlvl/zjEwmamzaDVwkBnTV4Ac9ZlGXytenZmJugHIgIcqhpvZX/uP0BpBYmB/hFqJuml8KgS2qUX6GGyU8+JenfTIkI39m9jJACTqnSPES7RrlS0K3gNPs2N6yeaVTp/IMVLD9MuxBoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727997346; c=relaxed/simple;
	bh=YGGf8LmMQMhmwN/JDIoQPBldD87z9FP50OGPKzJtMWo=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=LSYeDu0DESobWwNSMy9nXJEymhfBjXHQer93kaW/45R1h0lzytxShZRO1+EF06xLIDBoHOtJ5zpDGp3TCyut1UuIskOfVU3MtA3epzMTM0jJ48cozCCWJBUvA56GuSByGqKCc6JGrovkXObxN3uEE1hEg4Br3pA+FVJPjhM79EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org; spf=pass smtp.mailfrom=gentwo.org; dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b=nZ/230s2; arc=none smtp.client-ip=62.72.0.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentwo.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b="nZ/230s2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1727997338;
	bh=YGGf8LmMQMhmwN/JDIoQPBldD87z9FP50OGPKzJtMWo=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=nZ/230s2N9Zn3yZfyQkuhwTKs+2Y/cYftSJGE3qdCtN1jtgJliPkvwwCErrV4z2kY
	 Gh5ydVQoAomDlpOblMJ1/DxB/ItAk1TUUC8eoEVGSLtaFbV8xTagEvo4XFVaeT9AID
	 OS7Z4pPXMEJDT4Z2u2ZmnswIFRw3NiU4bx6LowaA=
Received: by gentwo.org (Postfix, from userid 1003)
	id 8956240B20; Thu,  3 Oct 2024 16:15:38 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 858D34027C;
	Thu,  3 Oct 2024 16:15:38 -0700 (PDT)
Date: Thu, 3 Oct 2024 16:15:38 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: mm-commits@vger.kernel.org, tj@kernel.org, dennis@kernel.org, 
    aha310510@gmail.com
Subject: Re: [failures] mm-percpu-fix-typo-to-pcpu_alloc_noprof-description.patch
 removed from -mm tree
In-Reply-To: <20241003192838.790ABC4CEC5@smtp.kernel.org>
Message-ID: <e91916d5-b712-0920-9b18-0a643cc46c74@gentwo.org>
References: <20241003192838.790ABC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Thu, 3 Oct 2024, Andrew Morton wrote:

> This patch was dropped because it had testing failures

A change to a comment causes testing failures? Really?

