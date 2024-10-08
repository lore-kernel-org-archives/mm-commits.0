Received: from cvs.openbsd.org (cvs.openbsd.org [199.185.137.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C5A18C922
	for <mm-commits@vger.kernel.org>; Tue,  8 Oct 2024 19:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.185.137.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728414124; cv=none; b=kVPnwrQd04tWXqN0RuY/Bbew1W2JDKqVOdRWu5a8uL+0argKNawkNsNoJmE334Gy2gz7vClFLtrHtettFr0jQ2NfypE6LWy+x5H+8Kzs4Vyraeu4g5TPi8y6E0daV0eWR+HiDVpkHZu0wxQIZDnDOOeIPK74lb8V27fyFswyHcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728414124; c=relaxed/simple;
	bh=VqTJu6nBJJ/x6+p0lAUlNwzdQ46rpyqDXHAPpE2hk+c=;
	h=From:Date:To:Subject:Message-ID; b=niHkZbbFD/amzYK7Sc7+nqH/OiZpol11H+88cBPwqmt+tgFuE/ykDU3BMt0IRUIi22VbzA6zeG3JreeAIeXlJWTdDxjXtNM6pWuLWNe1ZDWHl/q9BhGHyZeGWr4o29M6fbHBUdZmiYaIAcAWYtRMmhOlOm9GIi4YMKshhno3Mk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cvs.openbsd.org; spf=pass smtp.mailfrom=openbsd.org; dkim=pass (2048-bit key) header.d=openbsd.org header.i=@openbsd.org header.b=L4rOTmHJ; arc=none smtp.client-ip=199.185.137.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cvs.openbsd.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openbsd.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=openbsd.org header.i=@openbsd.org header.b="L4rOTmHJ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; s=selector1; bh=VqTJu6nBJJ
	/x6+p0lAUlNwzdQ46rpyqDXHAPpE2hk+c=; h=subject:to:date:from;
	d=openbsd.org; b=L4rOTmHJK9dKvLN6FXLrOtqKIKFk+Y7G52zPt1jmvq+JigsmBd4WK
	J9tKp5FSYuGwe3tRAVlHjVtF7OM/TN977nvkZpv6++T6LrwHY/8pb3ByqJ4RF3jVj8/LST
	/oPEjh8x1amemTZf8wOXjyDVX/FQOxyKK8Sn7rRmi2rgN2QeVsmbaAwx31zYMCopLCrqnK
	GPIXpBd00A1uf20qlGrWdi9nleGY9Wx/6Zw1+QNnKMd16GqAbyzp38JAzrcjJTJr1Su8Rz
	qxJLM5XIjEONCZsy+28Q6AJGoehkGQlqVH1UpX8mdndnDdUW2s8DpGanQDimDXof8z4ocS
	aFIRb9cQA==
Received: from localhost (cvs.openbsd.org [local])
	by cvs.openbsd.org (OpenSMTPD) with ESMTPA id e9ee96de;
	Tue, 8 Oct 2024 13:01:54 -0600 (MDT)
From: Theo de Raadt <deraadt@cvs.openbsd.org>
Date: Tue, 8 Oct 2024 13:01:54 -0600 (MDT)
To: akpm@linux-foundation.org, corbet@lwn.net, deraadt@openbsd.org,
    enh@google.com, gregkh@linuxfoundation.org, groeck@chromium.org,
    jannh@google.com, jeffxu@chromium.org, jorgelo@chromium.org,
    keescook@chromium.org, Liam.Howlett@oracle.com,
    lorenzo.stoakes@oracle.com, mm-commits@vger.kernel.org,
    pedro.falcato@gmail.com, rdunlap@infradead.org,
    sroettger@google.com, surenb@google.com,
    torvalds@linux-foundation.org, usama.anjum@collabora.com,
    willy@infradead.org
Subject: Re: + mseal-update-msealrst.patch added to mm-hotfixes-unstable branch
Message-ID: <f3c123e0624a07e0@cvs.openbsd.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

>-Additional notes:
>-=================
> As Jann Horn pointed out in [3], there are still a few ways to write
>-to RO memory, which is, in a way, by design. Those cases are not covered
>-by mseal(). If applications want to block such cases, sandbox tools (such as
>-seccomp, LSM, etc) might be considered.
>+to RO memory, which is, in a way, by design. And those could be blocked
>+by different security measures.
> 
> Those cases are:
> 
>-- Write to read-only memory through /proc/self/mem interface.
>-- Write to read-only memory through ptrace (such as PTRACE_POKETEXT).
>-- userfaultfd.
>+   - Write to read-only memory through /proc/self/mem interface (FOLL_FORCE).
>+   - Write to read-only memory through ptrace (such as PTRACE_POKETEXT).
>+   - userfaultfd.

This block of notes keeps bothering me, because I've encountered a bunch
of people who walk away with "oh but what's the purpose of this thing then
it is useless".

mimmutable and mseal are about restricting playing with the permission of
the *MAPPING* of memory, not about restricting the memory itself.

If it is going to remain, should it also say?

   - Write to a non-readonly mapping of the same memory object shared
     by a a different process, or shared to a different address in the
     same process, which is not read-only  (and this is a thing many
     older JIT do)

To wit, this is not because of mseal.  It is not because of the mapping
of the memory.  It is not because of the mapping of the memory.  It is
because a different interface to reach the same memory can always act.
It is because the permissions on one mapping obviously do not apply to
another mapping or access method.  Permissions apply to mappings, not to
memory.

A note: many decades ago, the Sun / CSRG named these calls mmap, munmap,
and mprotect.  The word "map" in mmap suggests the leading "m" is "memory".
With mprotect this gets confusing, because with shared mappings on the
same memory, it does not protect the memory, only the access via the
mapping region. "mseal" and "mimmutable" fall into the same catagory
where "m" refers to "mapping", not to "memory"; memory is actual bits
and bytes which may be mapped twice or more in circumstances.


