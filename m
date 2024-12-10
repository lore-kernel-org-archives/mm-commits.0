Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3323413635E
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 04:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733803363; cv=none; b=pXPf1naI/wI38PtwyN+D92Ee6AclDEBxplgn4IKt7A8ehDVMhPbIRowlTc4oCipaJxi79byKyBjwJUOe8VzKfVg0k0C8PMt01bM6ud/v0eVyO51zEZlr3AGdkeXCy1cwJC9JmlaxX+apGFlEqCO/8PXFdUO6h8rk5ELfvk+aFUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733803363; c=relaxed/simple;
	bh=RX1FYP+YJ3zxYOyQmnf2Ip9DioCcQA28k6MPQyzPIUg=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=mcfnS6YX0zaOycsTJHaKsy19o4DY15tx6aR45rVq+prnEvyhYnKehBSv6HF3cFh5OxyZo98VSjZ0OH1ZySFDmvi5SVa1nO0iT9txzylnruduSCosdyVgZcqBc+3MUF35ADeC+q2/AJHQfPXWpi4ds3Q11pKq4ladRikKG+W8OUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UvbX/J4r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UvbX/J4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6031FC4CED6;
	Tue, 10 Dec 2024 04:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733803362;
	bh=RX1FYP+YJ3zxYOyQmnf2Ip9DioCcQA28k6MPQyzPIUg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UvbX/J4rbMOOGMKjrd5QVxI0QOWRFPVUDazpkeQY5mbt1hi1URff9eEyjBXQzny60
	 1yystUGU/vV0QKWpfGkIAi+q4huNBU+LRwpXKr1QFSZxZWFOAsTeeQOyM5jP21QK7v
	 nviBmtudc/17owt4dY3ruXt5CdGIPWktb6UpV3wA=
Date: Mon, 9 Dec 2024 20:02:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: mm-commits@vger.kernel.org, will@kernel.org, kees@kernel.org,
 catalin.marinas@arm.com
Subject: Re: +
 mm-execmem-make-arch_wants_execmem_late-depend-on-execmem.patch added to
 mm-unstable branch
Message-Id: <20241209200241.dbbd3103e9386dc17da4d39e@linux-foundation.org>
In-Reply-To: <7627f30c-d68f-486c-b236-3bb78c4c46c5@arm.com>
References: <20241210031044.23B8FC4CED1@smtp.kernel.org>
	<7627f30c-d68f-486c-b236-3bb78c4c46c5@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 10 Dec 2024 09:12:39 +0530 Anshuman Khandual <anshuman.khandual@arm.com> wrote:

> As Catalin has explained earlier on the thread, we might just need
> to drop the EXECMEM dependency in the platform, and not change the
> generic config definition. Hence this patch needs some change.

I'll drop it.  Please send a v2.
