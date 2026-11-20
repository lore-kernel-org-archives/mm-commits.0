Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795174974;
	b=Y6XZ7QLFyNRG25Az1/nkVtHc8A90QRQHyU8le9ATLPrgXRWUe+/f/sLJzb+UZZc5vZWg
	 W3aWPvEcgGqZ2VgsZOovyGOi9xAOseDFL5++cY5S2xtAiF7SnKP7El/8g52l1ZUSxNUz+
	 XcipwlKR7Fd1IaEKfMVuPz0Ndnxr9nyBH7gNc3z9LRmSuC2iCV9raZeKFywSjjIYfkQf/
	 Sd2EFUkaVVEPRONIY8QZfLDemdio/NC2mioZOqP+q7l3ycDvM30JR6Qkr5+N8usZPzjxf
	 lTwkVj2DbONlSoLI3V7SwQhveY1r2XDLGmC5cndoNsctJRslQqfSzhj8uMvg4oq0WKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795174974;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:From:
	 Content-Language:To:Cc:Subject:Autocrypt:Content-Type:
	 Content-Transfer-Encoding;
	bh=JLWQKcUyPttq3BX20r7XpiTQm2t7oQ660Zdz7gVyNnE=;
	b=Sx9lejV5xzTCTcsoqFkSxAcskia8MMzcf2I2KKS9DRdle7IAh+knAPCO5YJOdndyxf5I
	 RJjkrcfOf83rEzLIkq8EaEFGWPWos2BhZSlI5VsjdFIVwTxduW1P6LAvaXAAku+NgyX6Y
	 VBVzGToKUUKjRwCoLR6opN6zFeRgrF4yMJEiiDiAnaOLUO7QGTM/XTVfnmuKtYaME4g2Q
	 tFTTe9jIPu42jMOb6RMK+JENjs2uKpKvCAuziqSiA5pblPTSyPXNGNZrJHSCBXy7uRuCo
	 q7wBo8nCgYnAHQrnopMK/dptpkHTJnx1CLJCJXELiMoY1w9fl3UVp+xXcbhlmjUrtYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bDkaQYkj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5DF60A2601
	for <mm-commits@vger.kernel.org>; Fri, 20 Nov 2026 11:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bDkaQYkj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D82E1F000D1;
	Fri, 20 Nov 2026 11:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795174974;
	bh=JLWQKcUyPttq3BX20r7XpiTQm2t7oQ660Zdz7gVyNnE=;
	h=Date:From:To:Cc:Subject;
	b=bDkaQYkjFMUL4yq0AJl8CKum5VrKYhOo/OJeaCVN1HTl9CNA87H+UpGsnLaEWs1Wl
	 fcj7ZE3iWXUapnC37diAQ5zM6HaGztjPjVfQxLq2J3XyjQwh+nSM4Ev2gTRKmD6NU9
	 vOuYTwxNRN4gWQCdwk3PSULPduSij+9p4kIbLHm2TcJD035v1evNaskbokZFguaE3l
	 FbtMguEzgmtTMMZcemlAM4jpqXjHAUFCEfiZPIpTEtlI8NzAKZEva6jhPOezTKTJOE
	 4biy/Ngi9V7ejFnKWnahfHX4Jl0KvvYm860J6iQzfKQ4zn1IuUT+oiS84+7uJLP6GP
	 +/YaxVQLXWTJA==
Message-ID: <4e5b70ca-63b5-4e82-a327-58398c73ca05@kernel.org>
Date: Fri, 20 Nov 2026 12:42:50 +0100
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>
Cc: "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>
Subject: mm-next: manual merge of the akpm/mm-unstable branch
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

today's mm-next merge of the akpm/mm-unstable branch tree got a conflict in:

  include/linux/alloc_tag.h

between the commit:

  cd890190497b alloc_tag: handle a NULL tag in alloc_tag_set_inaccurate()

from the page_alloc/page_alloc/for-next branch and the commit:

  5f15df08db91 alloc_tag: introduce IOCTLs to toggle allocation tracepoints

from the akpm/mm-unstable branch.

I resolved the conflicts manually:

    # Conflict resolution:
    #
    # diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
    # index ad968d79eb3a..d3317e197787 100644
    # --- a/include/linux/alloc_tag.h
    # +++ b/include/linux/alloc_tag.h
    # @@ -138,7 +138,8 @@ static inline bool mem_alloc_profiling_enabled(void)
    #
    #  static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
    #  {
    # -     atomic_or(CODETAG_FLAG_INACCURATE, &tag->ct.flags);
    # +     if (tag)
    # +             atomic_or(CODETAG_FLAG_INACCURATE, &tag->ct.flags);
    #  }
    #
    #  static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
    # @@ -283,20 +284,6 @@ static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes, const voi
    #       ref->ct = NULL;
    #  }
    #
    # -<<<<<<< HEAD
    # -static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
    # -{
    # -     if (tag)
    # -             tag->ct.flags |= CODETAG_FLAG_INACCURATE;
    # -}
    # -
    # -static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
    # -{
    # -     return !!(tag->ct.flags & CODETAG_FLAG_INACCURATE);
    # -}
    # -
    # -=======
    # ->>>>>>> akpm/mm-unstable
    #  #define alloc_tag_record(p)  ((p) = current->alloc_tag)
    #
    #  #else /* CONFIG_MEM_ALLOC_PROFILING */


-- 
Cheers,

David
