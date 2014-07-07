From: akpm@linux-foundation.org
Subject: + zlib-cleanup-some-dead-code.patch added to -mm tree
Date: Mon, 07 Jul 2014 15:03:21 -0700
Message-ID: <53bb1929.VaJJbRTSKKKX01y1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:38446 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaGGWDW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 18:03:22 -0400
Received: by mail-ve0-f201.google.com with SMTP id i13so24750veh.4
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 15:03:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zlib: clean up some dead code
has been added to the -mm tree.  Its filename is
     zlib-cleanup-some-dead-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zlib-cleanup-some-dead-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zlib-cleanup-some-dead-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zlib: clean up some dead code

Cleanup unused `if 0'-ed functions, which have been dead since 2006
(commits 87c2ce3b9305b ("lib/zlib*: cleanups") by Adrian Bunk and
4f3865fb57a04 ("zlib_inflate: Upgrade library code to a recent version")
by Richard Purdie):

 - zlib_deflateSetDictionary
 - zlib_deflateParams
 - zlib_deflateCopy
 - zlib_inflateSync
 - zlib_syncsearch
 - zlib_inflateSetDictionary
 - zlib_inflatePrime

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zlib.h       |  118 ----------------------------
 lib/zlib_deflate/deflate.c |  143 -----------------------------------
 lib/zlib_inflate/inflate.c |  132 --------------------------------
 3 files changed, 393 deletions(-)

diff -puN include/linux/zlib.h~zlib-cleanup-some-dead-code include/linux/zlib.h
--- a/include/linux/zlib.h~zlib-cleanup-some-dead-code
+++ a/include/linux/zlib.h
@@ -493,64 +493,6 @@ extern int deflateInit2 (z_streamp strm,
    method). msg is set to null if there is no error message.  deflateInit2 does
    not perform any compression: this will be done by deflate().
 */
-                            
-#if 0
-extern int zlib_deflateSetDictionary (z_streamp strm,
-						     const Byte *dictionary,
-						     uInt  dictLength);
-#endif
-/*
-     Initializes the compression dictionary from the given byte sequence
-   without producing any compressed output. This function must be called
-   immediately after deflateInit, deflateInit2 or deflateReset, before any
-   call of deflate. The compressor and decompressor must use exactly the same
-   dictionary (see inflateSetDictionary).
-
-     The dictionary should consist of strings (byte sequences) that are likely
-   to be encountered later in the data to be compressed, with the most commonly
-   used strings preferably put towards the end of the dictionary. Using a
-   dictionary is most useful when the data to be compressed is short and can be
-   predicted with good accuracy; the data can then be compressed better than
-   with the default empty dictionary.
-
-     Depending on the size of the compression data structures selected by
-   deflateInit or deflateInit2, a part of the dictionary may in effect be
-   discarded, for example if the dictionary is larger than the window size in
-   deflate or deflate2. Thus the strings most likely to be useful should be
-   put at the end of the dictionary, not at the front.
-
-     Upon return of this function, strm->adler is set to the Adler32 value
-   of the dictionary; the decompressor may later use this value to determine
-   which dictionary has been used by the compressor. (The Adler32 value
-   applies to the whole dictionary even if only a subset of the dictionary is
-   actually used by the compressor.)
-
-     deflateSetDictionary returns Z_OK if success, or Z_STREAM_ERROR if a
-   parameter is invalid (such as NULL dictionary) or the stream state is
-   inconsistent (for example if deflate has already been called for this stream
-   or if the compression method is bsort). deflateSetDictionary does not
-   perform any compression: this will be done by deflate().
-*/
-
-#if 0
-extern int zlib_deflateCopy (z_streamp dest, z_streamp source);
-#endif
-
-/*
-     Sets the destination stream as a complete copy of the source stream.
-
-     This function can be useful when several compression strategies will be
-   tried, for example when there are several ways of pre-processing the input
-   data with a filter. The streams that will be discarded should then be freed
-   by calling deflateEnd.  Note that deflateCopy duplicates the internal
-   compression state which can be quite large, so this strategy is slow and
-   can consume lots of memory.
-
-     deflateCopy returns Z_OK if success, Z_MEM_ERROR if there was not
-   enough memory, Z_STREAM_ERROR if the source stream state was inconsistent
-   (such as zalloc being NULL). msg is left unchanged in both source and
-   destination.
-*/
 
 extern int zlib_deflateReset (z_streamp strm);
 /*
@@ -568,27 +510,6 @@ static inline unsigned long deflateBound
 	return s + ((s + 7) >> 3) + ((s + 63) >> 6) + 11;
 }
 
-#if 0
-extern int zlib_deflateParams (z_streamp strm, int level, int strategy);
-#endif
-/*
-     Dynamically update the compression level and compression strategy.  The
-   interpretation of level and strategy is as in deflateInit2.  This can be
-   used to switch between compression and straight copy of the input data, or
-   to switch to a different kind of input data requiring a different
-   strategy. If the compression level is changed, the input available so far
-   is compressed with the old level (and may be flushed); the new level will
-   take effect only at the next call of deflate().
-
-     Before the call of deflateParams, the stream state must be set as for
-   a call of deflate(), since the currently available input may have to
-   be compressed and flushed. In particular, strm->avail_out must be non-zero.
-
-     deflateParams returns Z_OK if success, Z_STREAM_ERROR if the source
-   stream state was inconsistent or if a parameter was invalid, Z_BUF_ERROR
-   if strm->avail_out was zero.
-*/
-
 /*   
 extern int inflateInit2 (z_streamp strm, int  windowBits);
 
@@ -631,45 +552,6 @@ extern int inflateInit2 (z_streamp strm,
    and avail_out are unchanged.)
 */
 
-extern int zlib_inflateSetDictionary (z_streamp strm,
-						     const Byte *dictionary,
-						     uInt  dictLength);
-/*
-     Initializes the decompression dictionary from the given uncompressed byte
-   sequence. This function must be called immediately after a call of inflate,
-   if that call returned Z_NEED_DICT. The dictionary chosen by the compressor
-   can be determined from the adler32 value returned by that call of inflate.
-   The compressor and decompressor must use exactly the same dictionary (see
-   deflateSetDictionary).  For raw inflate, this function can be called
-   immediately after inflateInit2() or inflateReset() and before any call of
-   inflate() to set the dictionary.  The application must insure that the
-   dictionary that was used for compression is provided.
-
-     inflateSetDictionary returns Z_OK if success, Z_STREAM_ERROR if a
-   parameter is invalid (such as NULL dictionary) or the stream state is
-   inconsistent, Z_DATA_ERROR if the given dictionary doesn't match the
-   expected one (incorrect adler32 value). inflateSetDictionary does not
-   perform any decompression: this will be done by subsequent calls of
-   inflate().
-*/
-
-#if 0
-extern int zlib_inflateSync (z_streamp strm);
-#endif
-/* 
-    Skips invalid compressed data until a full flush point (see above the
-  description of deflate with Z_FULL_FLUSH) can be found, or until all
-  available input is skipped. No output is provided.
-
-    inflateSync returns Z_OK if a full flush point has been found, Z_BUF_ERROR
-  if no more input was provided, Z_DATA_ERROR if no flush point has been found,
-  or Z_STREAM_ERROR if the stream structure was inconsistent. In the success
-  case, the application may save the current current value of total_in which
-  indicates where valid compressed data was found. In the error case, the
-  application may repeatedly call inflateSync, providing more input each time,
-  until success or end of the input data.
-*/
-
 extern int zlib_inflateReset (z_streamp strm);
 /*
      This function is equivalent to inflateEnd followed by inflateInit,
diff -puN lib/zlib_deflate/deflate.c~zlib-cleanup-some-dead-code lib/zlib_deflate/deflate.c
--- a/lib/zlib_deflate/deflate.c~zlib-cleanup-some-dead-code
+++ a/lib/zlib_deflate/deflate.c
@@ -250,52 +250,6 @@ int zlib_deflateInit2(
 }
 
 /* ========================================================================= */
-#if 0
-int zlib_deflateSetDictionary(
-	z_streamp strm,
-	const Byte *dictionary,
-	uInt  dictLength
-)
-{
-    deflate_state *s;
-    uInt length = dictLength;
-    uInt n;
-    IPos hash_head = 0;
-
-    if (strm == NULL || strm->state == NULL || dictionary == NULL)
-	return Z_STREAM_ERROR;
-
-    s = (deflate_state *) strm->state;
-    if (s->status != INIT_STATE) return Z_STREAM_ERROR;
-
-    strm->adler = zlib_adler32(strm->adler, dictionary, dictLength);
-
-    if (length < MIN_MATCH) return Z_OK;
-    if (length > MAX_DIST(s)) {
-	length = MAX_DIST(s);
-#ifndef USE_DICT_HEAD
-	dictionary += dictLength - length; /* use the tail of the dictionary */
-#endif
-    }
-    memcpy((char *)s->window, dictionary, length);
-    s->strstart = length;
-    s->block_start = (long)length;
-
-    /* Insert all strings in the hash table (except for the last two bytes).
-     * s->lookahead stays null, so s->ins_h will be recomputed at the next
-     * call of fill_window.
-     */
-    s->ins_h = s->window[0];
-    UPDATE_HASH(s, s->ins_h, s->window[1]);
-    for (n = 0; n <= length - MIN_MATCH; n++) {
-	INSERT_STRING(s, n, hash_head);
-    }
-    if (hash_head) hash_head = 0;  /* to make compiler happy */
-    return Z_OK;
-}
-#endif  /*  0  */
-
-/* ========================================================================= */
 int zlib_deflateReset(
 	z_streamp strm
 )
@@ -326,45 +280,6 @@ int zlib_deflateReset(
     return Z_OK;
 }
 
-/* ========================================================================= */
-#if 0
-int zlib_deflateParams(
-	z_streamp strm,
-	int level,
-	int strategy
-)
-{
-    deflate_state *s;
-    compress_func func;
-    int err = Z_OK;
-
-    if (strm == NULL || strm->state == NULL) return Z_STREAM_ERROR;
-    s = (deflate_state *) strm->state;
-
-    if (level == Z_DEFAULT_COMPRESSION) {
-	level = 6;
-    }
-    if (level < 0 || level > 9 || strategy < 0 || strategy > Z_HUFFMAN_ONLY) {
-	return Z_STREAM_ERROR;
-    }
-    func = configuration_table[s->level].func;
-
-    if (func != configuration_table[level].func && strm->total_in != 0) {
-	/* Flush the last buffer: */
-	err = zlib_deflate(strm, Z_PARTIAL_FLUSH);
-    }
-    if (s->level != level) {
-	s->level = level;
-	s->max_lazy_match   = configuration_table[level].max_lazy;
-	s->good_match       = configuration_table[level].good_length;
-	s->nice_match       = configuration_table[level].nice_length;
-	s->max_chain_length = configuration_table[level].max_chain;
-    }
-    s->strategy = strategy;
-    return err;
-}
-#endif  /*  0  */
-
 /* =========================================================================
  * Put a short in the pending buffer. The 16-bit value is put in MSB order.
  * IN assertion: the stream state is correct and there is enough room in
@@ -568,64 +483,6 @@ int zlib_deflateEnd(
     return status == BUSY_STATE ? Z_DATA_ERROR : Z_OK;
 }
 
-/* =========================================================================
- * Copy the source state to the destination state.
- */
-#if 0
-int zlib_deflateCopy (
-	z_streamp dest,
-	z_streamp source
-)
-{
-#ifdef MAXSEG_64K
-    return Z_STREAM_ERROR;
-#else
-    deflate_state *ds;
-    deflate_state *ss;
-    ush *overlay;
-    deflate_workspace *mem;
-
-
-    if (source == NULL || dest == NULL || source->state == NULL) {
-        return Z_STREAM_ERROR;
-    }
-
-    ss = (deflate_state *) source->state;
-
-    *dest = *source;
-
-    mem = (deflate_workspace *) dest->workspace;
-
-    ds = &(mem->deflate_memory);
-
-    dest->state = (struct internal_state *) ds;
-    *ds = *ss;
-    ds->strm = dest;
-
-    ds->window = (Byte *) mem->window_memory;
-    ds->prev   = (Pos *)  mem->prev_memory;
-    ds->head   = (Pos *)  mem->head_memory;
-    overlay = (ush *) mem->overlay_memory;
-    ds->pending_buf = (uch *) overlay;
-
-    memcpy(ds->window, ss->window, ds->w_size * 2 * sizeof(Byte));
-    memcpy(ds->prev, ss->prev, ds->w_size * sizeof(Pos));
-    memcpy(ds->head, ss->head, ds->hash_size * sizeof(Pos));
-    memcpy(ds->pending_buf, ss->pending_buf, (uInt)ds->pending_buf_size);
-
-    ds->pending_out = ds->pending_buf + (ss->pending_out - ss->pending_buf);
-    ds->d_buf = overlay + ds->lit_bufsize/sizeof(ush);
-    ds->l_buf = ds->pending_buf + (1+sizeof(ush))*ds->lit_bufsize;
-
-    ds->l_desc.dyn_tree = ds->dyn_ltree;
-    ds->d_desc.dyn_tree = ds->dyn_dtree;
-    ds->bl_desc.dyn_tree = ds->bl_tree;
-
-    return Z_OK;
-#endif
-}
-#endif  /*  0  */
-
 /* ===========================================================================
  * Read a new buffer from the current input stream, update the adler32
  * and total number of bytes read.  All deflate() input goes through
diff -puN lib/zlib_inflate/inflate.c~zlib-cleanup-some-dead-code lib/zlib_inflate/inflate.c
--- a/lib/zlib_inflate/inflate.c~zlib-cleanup-some-dead-code
+++ a/lib/zlib_inflate/inflate.c
@@ -45,21 +45,6 @@ int zlib_inflateReset(z_streamp strm)
     return Z_OK;
 }
 
-#if 0
-int zlib_inflatePrime(z_streamp strm, int bits, int value)
-{
-    struct inflate_state *state;
-
-    if (strm == NULL || strm->state == NULL) return Z_STREAM_ERROR;
-    state = (struct inflate_state *)strm->state;
-    if (bits > 16 || state->bits + bits > 32) return Z_STREAM_ERROR;
-    value &= (1L << bits) - 1;
-    state->hold += value << state->bits;
-    state->bits += bits;
-    return Z_OK;
-}
-#endif
-
 int zlib_inflateInit2(z_streamp strm, int windowBits)
 {
     struct inflate_state *state;
@@ -761,123 +746,6 @@ int zlib_inflateEnd(z_streamp strm)
     return Z_OK;
 }
 
-#if 0
-int zlib_inflateSetDictionary(z_streamp strm, const Byte *dictionary,
-        uInt dictLength)
-{
-    struct inflate_state *state;
-    unsigned long id;
-
-    /* check state */
-    if (strm == NULL || strm->state == NULL) return Z_STREAM_ERROR;
-    state = (struct inflate_state *)strm->state;
-    if (state->wrap != 0 && state->mode != DICT)
-        return Z_STREAM_ERROR;
-
-    /* check for correct dictionary id */
-    if (state->mode == DICT) {
-        id = zlib_adler32(0L, NULL, 0);
-        id = zlib_adler32(id, dictionary, dictLength);
-        if (id != state->check)
-            return Z_DATA_ERROR;
-    }
-
-    /* copy dictionary to window */
-    zlib_updatewindow(strm, strm->avail_out);
-
-    if (dictLength > state->wsize) {
-        memcpy(state->window, dictionary + dictLength - state->wsize,
-                state->wsize);
-        state->whave = state->wsize;
-    }
-    else {
-        memcpy(state->window + state->wsize - dictLength, dictionary,
-                dictLength);
-        state->whave = dictLength;
-    }
-    state->havedict = 1;
-    return Z_OK;
-}
-#endif
-
-#if 0
-/*
-   Search buf[0..len-1] for the pattern: 0, 0, 0xff, 0xff.  Return when found
-   or when out of input.  When called, *have is the number of pattern bytes
-   found in order so far, in 0..3.  On return *have is updated to the new
-   state.  If on return *have equals four, then the pattern was found and the
-   return value is how many bytes were read including the last byte of the
-   pattern.  If *have is less than four, then the pattern has not been found
-   yet and the return value is len.  In the latter case, zlib_syncsearch() can be
-   called again with more data and the *have state.  *have is initialized to
-   zero for the first call.
- */
-static unsigned zlib_syncsearch(unsigned *have, unsigned char *buf,
-        unsigned len)
-{
-    unsigned got;
-    unsigned next;
-
-    got = *have;
-    next = 0;
-    while (next < len && got < 4) {
-        if ((int)(buf[next]) == (got < 2 ? 0 : 0xff))
-            got++;
-        else if (buf[next])
-            got = 0;
-        else
-            got = 4 - got;
-        next++;
-    }
-    *have = got;
-    return next;
-}
-#endif
-
-#if 0
-int zlib_inflateSync(z_streamp strm)
-{
-    unsigned len;               /* number of bytes to look at or looked at */
-    unsigned long in, out;      /* temporary to save total_in and total_out */
-    unsigned char buf[4];       /* to restore bit buffer to byte string */
-    struct inflate_state *state;
-
-    /* check parameters */
-    if (strm == NULL || strm->state == NULL) return Z_STREAM_ERROR;
-    state = (struct inflate_state *)strm->state;
-    if (strm->avail_in == 0 && state->bits < 8) return Z_BUF_ERROR;
-
-    /* if first time, start search in bit buffer */
-    if (state->mode != SYNC) {
-        state->mode = SYNC;
-        state->hold <<= state->bits & 7;
-        state->bits -= state->bits & 7;
-        len = 0;
-        while (state->bits >= 8) {
-            buf[len++] = (unsigned char)(state->hold);
-            state->hold >>= 8;
-            state->bits -= 8;
-        }
-        state->have = 0;
-        zlib_syncsearch(&(state->have), buf, len);
-    }
-
-    /* search available input */
-    len = zlib_syncsearch(&(state->have), strm->next_in, strm->avail_in);
-    strm->avail_in -= len;
-    strm->next_in += len;
-    strm->total_in += len;
-
-    /* return no joy or set up to restart inflate() on a new block */
-    if (state->have != 4) return Z_DATA_ERROR;
-    in = strm->total_in;  out = strm->total_out;
-    zlib_inflateReset(strm);
-    strm->total_in = in;  strm->total_out = out;
-    state->mode = TYPE;
-    return Z_OK;
-}
-#endif
